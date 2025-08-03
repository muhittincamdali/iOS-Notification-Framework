# Contributing to iOS Notification Framework

Thank you for your interest in contributing to the iOS Notification Framework! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

We welcome contributions from the community! Here are the main ways you can contribute:

### 🐛 Bug Reports

- Use the [GitHub Issues](https://github.com/muhittincamdali/iOS-Notification-Framework/issues) page
- Include detailed steps to reproduce the issue
- Provide system information (iOS version, device, etc.)
- Include relevant code snippets and error messages

### 💡 Feature Requests

- Submit feature requests through [GitHub Issues](https://github.com/muhittincamdali/iOS-Notification-Framework/issues)
- Clearly describe the feature and its benefits
- Include use cases and examples
- Consider the impact on existing functionality

### 📝 Documentation

- Improve existing documentation
- Add new examples and tutorials
- Fix typos and clarify unclear sections
- Translate documentation to other languages

### 🧪 Testing

- Write unit tests for new features
- Improve test coverage
- Report test failures
- Create integration tests

### 🔧 Code Contributions

- Fork the repository
- Create a feature branch
- Make your changes
- Write tests for new functionality
- Submit a pull request

## 🛠️ Development Setup

### Prerequisites

- Xcode 15.0 or later
- iOS 15.0+ deployment target
- Swift 5.9 or later
- macOS 13.0 or later

### Getting Started

1. **Fork the repository**
   ```bash
   git clone https://github.com/your-username/iOS-Notification-Framework.git
   cd iOS-Notification-Framework
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```

3. **Run tests**
   ```bash
   swift test
   ```

4. **Build the framework**
   ```bash
   swift build
   ```

## 📋 Coding Standards

### Swift Style Guide

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and maintain consistency with Apple's frameworks.

#### Naming Conventions

- **Types**: Use `PascalCase` for classes, structs, enums, and protocols
- **Functions and Variables**: Use `camelCase`
- **Constants**: Use `camelCase` for local constants, `UPPER_SNAKE_CASE` for global constants
- **Acronyms**: Treat as words (e.g., `URL`, `HTTP`)

#### Code Organization

```swift
// MARK: - Imports
import Foundation
import UserNotifications

// MARK: - Protocols
protocol NotificationManagerDelegate: AnyObject {
    func notificationManager(_ manager: NotificationManager, didReceiveNotification notification: UNNotification)
}

// MARK: - Classes
public class NotificationManager {
    // MARK: - Properties
    public static let shared = NotificationManager()
    
    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    public func requestPermissions() async throws -> Bool {
        // Implementation
    }
    
    // MARK: - Private Methods
    private func setupNotificationCategories() {
        // Implementation
    }
}
```

#### Documentation

- Use Swift documentation comments for all public APIs
- Include parameter descriptions, return values, and examples
- Follow Apple's documentation style

```swift
/// Manages notification permissions and scheduling.
///
/// The `NotificationManager` provides a high-level interface for working with
/// local and remote notifications. It handles permission requests, notification
/// scheduling, and user interaction responses.
///
/// ## Example Usage
/// ```swift
/// let manager = NotificationManager.shared
/// let granted = try await manager.requestPermissions()
/// if granted {
///     manager.schedule(notification, at: Date().addingTimeInterval(60))
/// }
/// ```
public class NotificationManager {
    // Implementation
}
```

### Testing Standards

- Write unit tests for all public APIs
- Aim for 100% test coverage
- Use descriptive test names
- Follow the Arrange-Act-Assert pattern

```swift
class NotificationManagerTests: XCTestCase {
    func testRequestPermissions_WhenGranted_ReturnsTrue() async throws {
        // Arrange
        let manager = NotificationManager.shared
        
        // Act
        let result = try await manager.requestPermissions()
        
        // Assert
        XCTAssertTrue(result)
    }
}
```

## 🔄 Pull Request Process

### Before Submitting

1. **Ensure tests pass**
   ```bash
   swift test
   ```

2. **Check code style**
   - Follow Swift style guidelines
   - Use proper indentation (4 spaces)
   - Remove trailing whitespace

3. **Update documentation**
   - Update README.md if needed
   - Add documentation comments for new APIs
   - Update CHANGELOG.md for significant changes

4. **Test your changes**
   - Test on different iOS versions
   - Test on different device types
   - Verify performance impact

### Pull Request Guidelines

1. **Create a descriptive title**
   - Use present tense ("Add feature" not "Added feature")
   - Be specific about the change

2. **Write a detailed description**
   - Explain what the change does
   - Include motivation and context
   - Reference related issues

3. **Include tests**
   - Add unit tests for new functionality
   - Update existing tests if needed
   - Ensure all tests pass

4. **Update documentation**
   - Update relevant documentation
   - Add examples for new features
   - Update API documentation

### Review Process

1. **Automated checks must pass**
   - All tests must pass
   - Code coverage must not decrease
   - No linting errors

2. **Code review**
   - At least one maintainer must approve
   - Address all review comments
   - Make requested changes

3. **Final approval**
   - Maintainer will merge after approval
   - Changes will be included in next release

## 🏷️ Issue Labels

We use the following labels to categorize issues:

- **bug**: Something isn't working
- **enhancement**: New feature or request
- **documentation**: Improvements or additions to documentation
- **good first issue**: Good for newcomers
- **help wanted**: Extra attention is needed
- **priority: high**: High priority issue
- **priority: low**: Low priority issue
- **question**: Further information is requested
- **wontfix**: This will not be worked on

## 📚 Resources

### Documentation

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)

### Tools

- **Xcode**: Primary development environment
- **Swift Package Manager**: Dependency management
- **GitHub**: Version control and collaboration
- **SwiftLint**: Code style enforcement (optional)

## 🎯 Contribution Areas

### High Priority

- **Performance improvements**: Optimize notification scheduling and delivery
- **Bug fixes**: Critical issues affecting functionality
- **Security enhancements**: Improve data protection and privacy
- **Accessibility**: Enhance accessibility features

### Medium Priority

- **New features**: Additional notification capabilities
- **Documentation**: Improve guides and examples
- **Testing**: Increase test coverage
- **Examples**: Add more usage examples

### Low Priority

- **Code style**: Minor formatting improvements
- **Documentation**: Typo fixes and clarifications
- **Examples**: Additional edge case examples

## 🏆 Recognition

Contributors will be recognized in the following ways:

- **Contributors list**: Added to README.md contributors section
- **Release notes**: Mentioned in CHANGELOG.md for significant contributions
- **GitHub profile**: Contributions appear on your GitHub profile
- **Community**: Recognition in community discussions and events

## 📞 Getting Help

If you need help with contributing:

- **GitHub Issues**: Ask questions in issues
- **GitHub Discussions**: Use discussions for general questions
- **Documentation**: Check the [Documentation](Documentation/) folder
- **Examples**: Review the [Examples](Examples/) folder

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the same MIT License as the project.

---

Thank you for contributing to the iOS Notification Framework! Your contributions help make this framework better for the entire iOS development community.

**Made with ❤️ by the iOS Notification Framework Team** 