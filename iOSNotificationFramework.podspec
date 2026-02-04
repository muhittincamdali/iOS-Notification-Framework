Pod::Spec.new do |s|
  s.name             = 'iOSNotificationFramework'
  s.version          = '1.0.0'
  s.summary          = 'Complete push notification framework for iOS with rich notifications.'
  s.description      = <<-DESC
    iOSNotificationFramework provides a complete push notification framework for iOS.
    Features include rich notifications, custom actions, notification categories,
    silent push handling, badge management, and deep linking support.
  DESC

  s.homepage         = 'https://github.com/muhittincamdali/iOS-Notification-Framework'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/iOS-Notification-Framework.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'UserNotifications'
end
