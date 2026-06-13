import SwiftUI
import UserNotifications

/// A SwiftUI view for previewing how a notification will look on the lock screen.
///
/// This provides immediate visual feedback for developers using NotificationKit.
public struct NotificationPreview: View {
    public let titleText: String
    public let bodyText: String
    public let subtitleText: String?
    public let category: String?
    public let date: Date
    
    public init(
        title: String,
        body: String,
        subtitle: String? = nil,
        category: String? = nil,
        date: Date = Date()
    ) {
        self.titleText = title
        self.bodyText = body
        self.subtitleText = subtitle
        self.category = category
        self.date = date
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "app.badge.fill")
                    .foregroundColor(.red)
                    .font(.caption)
                
                Text("NOTIFICATION")
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("now")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(titleText)
                    .font(.subheadline.bold())
                
                if let subtitle = subtitleText {
                    Text(subtitle)
                        .font(.footnote.bold())
                }
                
                Text(bodyText)
                    .font(.footnote)
                    .lineLimit(2)
                    .foregroundColor(.primary.opacity(0.9))
            }
        }
        .padding()
        .frame(maxWidth: 350)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

public extension View {
    /// Show a notification preview sheet for debugging
    func notificationPreviewSheet(isPresented: Binding<Bool>, title: String, body: String) -> some View {
        self.sheet(isPresented: isPresented) {
            ZStack {
                Color.black.ignoresSafeArea()
                NotificationPreview(title: title, body: body)
            }
        }
    }
}
