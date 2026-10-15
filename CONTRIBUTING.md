# Contributing

Thanks for taking the time to improve NotificationKit.

## Reporting bugs

Open an issue with:

- the notification or payload involved (with personal data and device tokens removed),
- what you expected and what happened,
- platform and OS version (simulator or device) and Xcode version.

Report security issues privately, as described in the
[security policy](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md), not in an
issue. That includes anything that lets a push payload, a deep link or a downloaded file make
the app crash, hang or open something it should not.

## Pull requests

1. Fork the repository and branch from `main`.
2. Keep each pull request focused on one change.
3. Run the tests on macOS and on an iOS simulator:

    ```sh
    swift test
    xcodebuild test -scheme NotificationKit-Package \
      -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
    ```

4. If you change scheduling, validation, payload or routing logic, add or update a test in
   `Tests/`. Scheduling tests use `InMemoryNotificationCenter` and a test clock, so they do not
   depend on the time of day or a device.
5. Code that reads input from outside the app (payloads, links, files, network answers) must
   bound how much memory and time it can use, and must range-check a `Double` before turning it
   into an `Int`. Add a test with hostile input.
6. If you change a README code sample, change the copy in
   `Examples/NotificationLab/NotificationLab/ReadmeSamples.swift` as well. That file is what gets
   compiled: by the example app, and by `swift test` through the symlink
   `Tests/NotificationKitTests/ReadmeExamples.swift`.
7. If you change the example app or event handling, run its UI tests
   (`Examples/README.md` shows how) and regenerate the screenshots with
   `scripts/capture-screenshots.sh`.
8. `README.md` has translations (`README.<language>.md`). Each one records the version of
   `README.md` it follows, and CI fails while a translation is behind. If you change `README.md`
   and cannot update the translations, say so in the pull request and they will be updated
   before it is merged.

## Code style

- Follow the [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- The package builds in the Swift 6 language mode; new code should not add warnings.
- Document public API with DocC comments (`///`), and keep `xcodebuild docbuild` free of
  warnings.
- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
  (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `ci:`, `chore:`).

## License

By contributing you agree that your contributions are licensed under the MIT License.
