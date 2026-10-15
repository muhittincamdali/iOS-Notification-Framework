import Foundation
import NotificationKit
import NotificationKitAPNs

let usage = """
Usage:
  nk-push payload --title <text> --body <text> [--deeplink <url>] [--media-url <url>]
                  [--bundle-id <id>] [--output <file>]
      Prints (or writes) an alert payload. With --bundle-id it can be passed to
      `xcrun simctl push booted <file>` to deliver it to a simulator.

  nk-push send --key <AuthKey.p8> --key-id <id> --team-id <id> --topic <bundle id>
               --token <hex> --title <text> --body <text> [--deeplink <url>] [--sandbox]
      Sends the alert to a device through APNs.
"""

/// Reads `--name value` pairs; flags without a value (such as --sandbox) map to "".
func parseOptions(_ arguments: ArraySlice<String>) -> [String: String] {
    var options: [String: String] = [:]
    var index = arguments.startIndex
    while index < arguments.endIndex {
        let name = arguments[index]
        guard name.hasPrefix("--") else { index += 1; continue }
        let next = arguments.index(after: index)
        if next < arguments.endIndex, !arguments[next].hasPrefix("--") {
            options[String(name.dropFirst(2))] = arguments[next]
            index = arguments.index(after: next)
        } else {
            options[String(name.dropFirst(2))] = ""
            index = next
        }
    }
    return options
}

func require(_ name: String, in options: [String: String]) throws -> String {
    guard let value = options[name], !value.isEmpty else { throw CommandError.missing(name) }
    return value
}

enum CommandError: Error, CustomStringConvertible {
    case missing(String)
    case unknownCommand

    var description: String {
        switch self {
        case .missing(let name): "Missing --\(name).\n\n\(usage)"
        case .unknownCommand: usage
        }
    }
}

// README: Sending from a server
func makePayload(options: [String: String]) throws -> PushPayload {
    var payload = PushPayload.alert(
        title: try require("title", in: options),
        body: try require("body", in: options)
    )
    if let link = options["deeplink"] {
        payload.deepLink = URL(string: link)
    }
    if let media = options["media-url"] {
        // Picked up by the app's Notification Service Extension (MediaAttachmentService).
        payload.aps.mutableContent = true
        payload.custom["media-url"] = .string(media)
    }
    return payload
}

func send(options: [String: String]) async throws {
    let key = try APNsSigningKey(
        p8File: URL(fileURLWithPath: try require("key", in: options)),
        keyID: try require("key-id", in: options),
        teamID: try require("team-id", in: options)
    )
    let client = APNsClient(key: key, environment: options["sandbox"] != nil ? .development : .production)
    let request = APNsRequest(
        payload: try makePayload(options: options),
        deviceToken: try DeviceToken(hexString: try require("token", in: options)),
        topic: try require("topic", in: options)
    )
    do {
        let delivery = try await client.send(request)
        print("Accepted by APNs, apns-id \(delivery.apnsID)")
    } catch let error as APNsError where error.isTokenInvalid {
        print("The token is no longer valid; delete it from your database. (\(error.reason?.rawValue ?? "410"))")
        throw error
    }
}
// README: end

func writePayload(options: [String: String]) throws {
    var payload = try makePayload(options: options)
    if let bundleID = options["bundle-id"] {
        payload.custom["Simulator Target Bundle"] = .string(bundleID)
    }
    let data = try payload.encoded(for: .alert)
    if let output = options["output"] {
        try data.write(to: URL(fileURLWithPath: output))
        print("Wrote \(data.count) bytes to \(output)")
    } else {
        print(String(decoding: data, as: UTF8.self))
    }
}

let arguments = CommandLine.arguments.dropFirst()
let options = parseOptions(arguments.dropFirst())
do {
    switch arguments.first {
    case "payload": try writePayload(options: options)
    case "send": try await send(options: options)
    default: throw CommandError.unknownCommand
    }
} catch {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(1)
}
