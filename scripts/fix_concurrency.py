import os
import re

dir_path = "<path>"

def fix_sendable():
    # 1. Update [String: Any] to [String: Sendable]
    files = [
        "Models/Notification.swift",
        "Core/ABTestingEngine.swift"
    ]
    for rel_path in files:
        path = os.path.join(dir_path, rel_path)
        with open(path, 'r') as f: content = f.read()
        content = content.replace('[String: Any]', '[String: Sendable]')
        with open(path, 'w') as f: f.write(content)
        print(f"Fixed Sendable in {rel_path}")

def fix_isolation():
    path = os.path.join(dir_path, "NotificationKit.swift")
    with open(path, 'r') as f: content = f.read()
    
    # 1. Make the delegate Sendable
    content = content.replace('public protocol NotificationKitDelegate: AnyObject {', 'public protocol NotificationKitDelegate: AnyObject, Sendable {')
    
    # 2. Fix assumeIsolated
    content = content.replace('MainActor.assumeIsolated { self }', 'self')
    
    with open(path, 'w') as f: f.write(content)
    print("Fixed isolation in NotificationKit.swift")

fix_sendable()
fix_isolation()
