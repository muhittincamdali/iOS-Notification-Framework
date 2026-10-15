#!/usr/bin/env bash
# Captures the README screenshots from the NotificationLab UI tests on an iPhone simulator, in
# light and dark appearance, and runs a push end to end on the way:
#
#   1. Examples/PushSender builds the push payload with NotificationKit's PushPayload.
#   2. The UI tests install the app fresh, allow notifications, schedule reminders, open a
#      banner and fill the queue past the 64-notification limit.
#   3. While testPushOpensOrder waits on the Home Screen, this script delivers the payload with
#      `xcrun simctl push`; the test taps the banner and checks that DeepLinkRouter opened the
#      order.
#
# Usage: scripts/capture-screenshots.sh [simulator name or UDID]
# Without an argument it uses the first available iPhone simulator. Output: docs/images/
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
bundle_id="io.github.muhittincamdali.NotificationLab"
output_dir="$repo_root/docs/images"
shots=(banner queue push-destination)
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$output_dir" "$work/shots"

device="${1:-}"
if [[ -z "$device" ]]; then
  device="$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')"
fi
if [[ "$device" =~ ^[0-9A-F-]{36}$ ]]; then
  udid="$device"
else
  udid="$(xcrun simctl list devices available | grep -m1 -F "$device (" | grep -oE '[0-9A-F-]{36}' || true)"
fi
if [[ -z "$udid" ]]; then
  echo "No available iPhone simulator found." >&2
  exit 1
fi

echo "Building the push payload"
payload="$work/order.apns"
(cd "$repo_root/Examples/PushSender" && swift run -q nk-push payload \
  --title "Order shipped" --body "A-1042 is on its way." \
  --deeplink "notificationlab://orders/A-1042" --bundle-id "$bundle_id" --output "$payload")

echo "Building NotificationLab for $udid"
xcodebuild build-for-testing \
  -project "$repo_root/Examples/NotificationLab/NotificationLab.xcodeproj" \
  -scheme NotificationLab -destination "id=$udid" -derivedDataPath "$work/build" -quiet

# The screenshots show SpringBoard, so the simulator runs in English (US).
xcrun simctl boot "$udid" 2>/dev/null || true
xcrun simctl bootstatus "$udid" -b >/dev/null
if [[ "$(xcrun simctl spawn "$udid" defaults read -g AppleLocale 2>/dev/null || true)" != "en_US" ]]; then
  echo "Switching the simulator to English (US)"
  xcrun simctl spawn "$udid" defaults write -g AppleLanguages -array en
  xcrun simctl spawn "$udid" defaults write -g AppleLocale -string en_US
  xcrun simctl shutdown "$udid"
  xcrun simctl boot "$udid"
  xcrun simctl bootstatus "$udid" -b >/dev/null
fi
xcrun simctl status_bar "$udid" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularBars 4 --wifiBars 3 --operatorName ""

for appearance in light dark; do
  xcrun simctl ui "$udid" appearance "$appearance"
  # A fresh install asks for permission again, so every run starts from the same state.
  xcrun simctl uninstall "$udid" "$bundle_id" 2>/dev/null || true
  marker="$work/push-ready-$appearance"

  # Sends the push once the test is waiting for it on the Home Screen.
  (
    for _ in $(seq 1 240); do
      if [[ -f "$marker" ]]; then
        sleep 2
        xcrun simctl push "$udid" "$payload"
        exit 0
      fi
      sleep 0.5
    done
    echo "The test never got ready for the push." >&2
  ) &
  sender=$!

  TEST_RUNNER_SCREENSHOT_DIR="$work/shots" TEST_RUNNER_APPEARANCE="$appearance" \
    TEST_RUNNER_PUSH_READY_FILE="$marker" \
    xcodebuild test-without-building \
      -project "$repo_root/Examples/NotificationLab/NotificationLab.xcodeproj" \
      -scheme NotificationLab -destination "id=$udid" -derivedDataPath "$work/build" \
      > "$work/test-$appearance.log" 2>&1 \
    || { kill "$sender" 2>/dev/null; grep -E "error:|failed" "$work/test-$appearance.log" >&2; exit 1; }
  wait "$sender"
done

for appearance in light dark; do
  for shot in "${shots[@]}"; do
    file="$output_dir/$shot-$appearance.png"
    cp "$work/shots/$shot-$appearance.png" "$file"
    # Half the width of an iPhone 17 Pro screenshot keeps the README light.
    sips --resampleWidth 603 "$file" >/dev/null
    echo "$file"
  done
done

xcrun simctl status_bar "$udid" clear
xcrun simctl terminate "$udid" "$bundle_id" 2>/dev/null || true
