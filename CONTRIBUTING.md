# Contributing to iOS Notification Framework

Thank you for your interest in contributing to the iOS Notification Framework! This document provides guidelines and information for contributors.

## 🤝 How to Contribute

We welcome contributions from the community! Whether you're fixing bugs, adding features, improving documentation, or suggesting ideas, your contributions help make this framework better for everyone.

### Types of Contributions

- **🐛 Bug Fixes**: Fix issues and improve stability
- **✨ New Features**: Add new functionality and capabilities
- **📚 Documentation**: Improve documentation and examples
- **🧪 Tests**: Add or improve test coverage
- **🔧 Performance**: Optimize performance and efficiency
- **🎨 UI/UX**: Enhance user experience and interface
- **🌐 Localization**: Add support for new languages
- **📖 Examples**: Create helpful examples and demos

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+**: Latest version of Xcode
- **iOS 15.0+**: Target iOS version
- **Swift 5.9+**: Latest Swift version
- **Git**: Version control system
- **GitHub Account**: For pull requests and issues

### Development Setup

1. **Fork the Repository**
   ```bash
   git clone https://github.com/your-username/iOS-Notification-Framework.git
   cd iOS-Notification-Framework
   ```

2. **Install Dependencies**
   ```bash
   # Swift Package Manager dependencies are automatically resolved
   # No additional installation required
   ```

3. **Open in Xcode**
   ```bash
   open Package.swift
   ```

4. **Run Tests**
   ```bash
   # In Xcode: Product > Test
   # Or via command line:
   swift test
   ```

## 📋 Development Guidelines

### Code Style

We follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/) and maintain consistent code style:

#### **Naming Conventions**
```swift
// ✅ Good
class NotificationManager { }
func scheduleNotification() { }
let notificationRequest: NotificationRequest

// ❌ Bad
class notification_manager { }
func ScheduleNotification() { }
let request: NotificationRequest
```

#### **Documentation**
```swift
/// Schedules a notification with the specified request
/// - Parameter request: The notification request to schedule
/// - Parameter completion: Completion handler called with the result
/// - Returns: A cancellable task for the scheduling operation
public func scheduleNotification(
    _ request: NotificationRequest,
    completion: @escaping (Result<String, NotificationError>) -> Void
) -> CancellableTask
```

#### **Error Handling**
```swift
// ✅ Good
enum NotificationError: Error, LocalizedError {
    case schedulingFailed(Error)
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .schedulingFailed(let error):
            return "Failed to schedule notification: \(error.localizedDescription)"
        case .permissionDenied:
            return "Notification permissions not granted"
        }
    }
}

// ❌ Bad
enum NotificationError: Error {
    case failed
}
```

### Architecture Principles

We follow **Clean Architecture** principles:

#### **Domain Layer**
```swift
// Entities
public struct NotificationRequest {
    public let identifier: String
    public let title: String
    public let body: String
    // ...
}

// Use Cases
public protocol ScheduleNotificationUseCase {
    func execute(_ request: NotificationRequest) async throws -> String
}

// Protocols
public protocol NotificationRepository {
    func schedule(_ request: NotificationRequest) async throws -> String
}
```

#### **Data Layer**
```swift
// Repositories
public class NotificationRepositoryImpl: NotificationRepository {
    private let dataSource: NotificationDataSource
    
    public func schedule(_ request: NotificationRequest) async throws -> String {
        // Implementation
    }
}
```

#### **Presentation Layer**
```swift
// ViewModels
public class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationRequest] = []
    
    func scheduleNotification(_ request: NotificationRequest) {
        // Implementation
    }
}
```

### Testing Guidelines

#### **Unit Tests**
```swift
class NotificationManagerTests: XCTestCase {
    var notificationManager: NotificationManager!
    
    override func setUpWithError() throws {
        super.setUp()
        notificationManager = NotificationManager.shared
    }
    
    func testNotificationScheduling() {
        // Given
        let request = NotificationRequest.simple(
            title: "Test",
            body: "Test Body"
        )
        
        // When
        let expectation = XCTestExpectation(description: "Notification scheduled")
        
        // Then
        XCTAssertTrue(request.isValid)
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
}
```

#### **Integration Tests**
```swift
class NotificationIntegrationTests: XCTestCase {
    func testCompleteNotificationFlow() {
        // Test complete notification flow
        // 1. Request permissions
        // 2. Schedule notification
        // 3. Verify delivery
        // 4. Test actions
    }
}
```

#### **Performance Tests**
```swift
func testNotificationSchedulingPerformance() {
    measure {
        for _ in 0..<1000 {
            _ = NotificationRequest.simple(
                title: "Performance Test",
                body: "Performance Test Body"
            )
        }
    }
}
```

## 🔄 Pull Request Process

### Before Submitting

1. **Update Documentation**
   - Update README.md if needed
   - Add inline documentation for new APIs
   - Update CHANGELOG.md with your changes

2. **Add Tests**
   - Unit tests for new functionality
   - Integration tests for complex features
   - Performance tests for critical paths

3. **Run Quality Checks**
   ```bash
   # Run tests
   swift test
   
   # Check code style (if using SwiftLint)
   swiftlint lint
   
   # Build for all platforms
   swift build
   ```

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Performance tests pass
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] CHANGELOG.md updated

## Screenshots (if applicable)
Add screenshots for UI changes

## Additional Notes
Any additional information
```

### Review Process

1. **Automated Checks**
   - CI/CD pipeline runs tests
   - Code coverage analysis
   - Performance regression tests

2. **Code Review**
   - At least one maintainer review required
   - Address all review comments
   - Update PR based on feedback

3. **Final Approval**
   - All tests must pass
   - Code coverage maintained
   - Documentation updated

## 🐛 Bug Reports

### Before Reporting

1. **Check Existing Issues**
   - Search existing issues for similar problems
   - Check closed issues for solutions

2. **Reproduce the Issue**
   - Provide clear steps to reproduce
   - Include sample code if applicable
   - Test on different devices/iOS versions

### Bug Report Template

```markdown
## Bug Description
Clear description of the bug

## Steps to Reproduce
1. Step 1
2. Step 2
3. Step 3

## Expected Behavior
What should happen

## Actual Behavior
What actually happens

## Environment
- iOS Version: 15.0+
- Device: iPhone/iPad
- Framework Version: 2.5.0
- Xcode Version: 15.0

## Sample Code
```swift
// Minimal code to reproduce the issue
```

## Additional Information
- Screenshots if applicable
- Crash logs if available
- Performance impact if relevant
```

## 💡 Feature Requests

### Before Requesting

1. **Check Existing Features**
   - Review current functionality
   - Check roadmap for planned features

2. **Research Alternatives**
   - Look for existing solutions
   - Consider workarounds

### Feature Request Template

```markdown
## Feature Description
Clear description of the requested feature

## Use Case
Why this feature is needed

## Proposed Solution
How you think it should work

## Alternatives Considered
Other approaches you've considered

## Additional Information
- Screenshots/mockups if applicable
- Related issues
- Implementation suggestions
```

## 📚 Documentation

### Documentation Standards

#### **API Documentation**
```swift
/// Advanced notification management system for iOS applications
/// Provides comprehensive notification handling with rich media support,
/// custom actions, scheduling, and analytics tracking
@available(iOS 15.0, *)
public final class NotificationManager: NSObject {
    
    /// Schedules a notification with the specified request
    /// - Parameter request: The notification request to schedule
    /// - Parameter completion: Completion handler called with the result
    /// - Returns: A cancellable task for the scheduling operation
    public func scheduleNotification(
        _ request: NotificationRequest,
        completion: @escaping (Result<String, NotificationError>) -> Void
    ) -> CancellableTask
}
```

#### **README Updates**
- Update installation instructions
- Add usage examples
- Update feature list
- Include migration guides

#### **CHANGELOG Updates**
- Add entries for all changes
- Follow semantic versioning
- Include breaking changes
- Document deprecations

## 🧪 Testing

### Test Coverage Requirements

- **Unit Tests**: 90%+ coverage for new code
- **Integration Tests**: For complex features
- **Performance Tests**: For critical paths
- **UI Tests**: For user-facing features

### Test Naming Convention

```swift
// ✅ Good
func testNotificationSchedulingWithValidRequest()
func testNotificationSchedulingFailsWithInvalidRequest()
func testNotificationCancellationRemovesFromQueue()

// ❌ Bad
func test1()
func testNotification()
func testStuff()
```

### Test Organization

```swift
class NotificationManagerTests: XCTestCase {
    
    // MARK: - Setup
    override func setUpWithError() throws {
        // Setup code
    }
    
    override func tearDownWithError() throws {
        // Cleanup code
    }
    
    // MARK: - Scheduling Tests
    func testNotificationScheduling() {
        // Test implementation
    }
    
    // MARK: - Cancellation Tests
    func testNotificationCancellation() {
        // Test implementation
    }
    
    // MARK: - Performance Tests
    func testNotificationSchedulingPerformance() {
        // Performance test
    }
}
```

## 🔧 Development Tools

### Recommended Tools

- **Xcode**: Primary development environment
- **SwiftLint**: Code style enforcement
- **SwiftFormat**: Code formatting
- **Instruments**: Performance profiling
- **GitHub Desktop**: Git client (optional)

### SwiftLint Configuration

```yaml
# .swiftlint.yml
disabled_rules:
  - trailing_whitespace
  - line_length

opt_in_rules:
  - empty_count
  - force_unwrapping
  - implicitly_unwrapped_optional

included:
  - Sources
  - Tests

excluded:
  - Documentation
  - Examples
```

## 📋 Code of Conduct

### Our Standards

- **Respectful Communication**: Be respectful and inclusive
- **Constructive Feedback**: Provide helpful, constructive feedback
- **Inclusive Environment**: Welcome contributors from all backgrounds
- **Professional Behavior**: Maintain professional standards

### Unacceptable Behavior

- **Harassment**: Any form of harassment or discrimination
- **Inappropriate Content**: Offensive or inappropriate content
- **Spam**: Unwanted promotional content
- **Trolling**: Deliberately disruptive behavior

## 🏆 Recognition

### Contributors Hall of Fame

We recognize and appreciate all contributors:

- **Core Contributors**: Regular contributors with significant impact
- **Bug Hunters**: Contributors who find and fix important bugs
- **Documentation Heroes**: Contributors who improve documentation
- **Test Champions**: Contributors who improve test coverage

### Recognition Levels

- **Bronze**: 1-5 contributions
- **Silver**: 6-15 contributions
- **Gold**: 16-30 contributions
- **Platinum**: 30+ contributions

## 📞 Getting Help

### Communication Channels

- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For questions and discussions
- **Email**: support@muhittincamdali.com
- **Documentation**: [Full Documentation](Documentation/)

### Response Times

- **Critical Bugs**: Within 24 hours
- **Feature Requests**: Within 1 week
- **General Questions**: Within 3 days
- **Documentation Issues**: Within 1 week

## 🙏 Acknowledgments

We appreciate all contributors who help make this framework better:

- **Code Contributors**: Developers who write code
- **Documentation Contributors**: Writers who improve docs
- **Test Contributors**: Testers who ensure quality
- **Community Members**: Users who provide feedback

---

**Thank you for contributing to the iOS Notification Framework! 🚀**

Your contributions help make this framework better for the entire iOS development community. 