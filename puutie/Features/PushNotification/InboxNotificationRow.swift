//
//  InboxNotificationRow.swift
//  puutie
//
//  Created by Gurhan on 11/30/25.
//

import SwiftUI

struct InboxNotificationRow: View {
    let notification: UserNotificationDto
    @EnvironmentObject var router: NavigationRouter
    
    private var isRead: Bool {
        notification.read ?? false
    }
    
    private var notificationIcon: String {
        switch notification.category {
        case "SECURITY":
            return "shield.fill"
        case "MESSAGE":
            return "message.fill"
        case "SYSTEM":
            return "gearshape.fill"
        default:
            return "bell.fill"
        }
    }
    
    private var iconColor: Color {
        switch notification.category {
        case "SECURITY":
            return .red
        case "MESSAGE":
            return .appAccent
        case "SYSTEM":
            return .blue
        default:
            return .appDarkAccent
        }
    }
    
    private var timeAgo: String {
        guard let createdAt = notification.createdAt else { return "" }
        let interval = Date().timeIntervalSince(createdAt)
        
        if interval < 60 {
            return "Az önce"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes) dk önce"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours) sa önce"
        } else {
            let days = Int(interval / 86400)
            return "\(days) gün önce"
        }
    }
    
    var body: some View {
        Button {
            if let target = notification.target,
                let route = Route(rawValue: target) {
                router.push(route)
            }
        } label: {
            HStack(spacing: 12) {
                // Icon Circle
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: notificationIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 8) {
                        Text(notification.title ?? "Bildirim")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isRead ? .primary : .primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        // Unread indicator
                        if !isRead {
                            Circle()
                                .fill(iconColor)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    if let body = notification.body, !body.isEmpty {
                        Text(body)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack(spacing: 4) {
                        Text(timeAgo)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                        
                        if let category = notification.category {
                            Text("•")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                            
                            Text(category)
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                // Chevron
                if notification.target != nil {
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(12)
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 14, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(.white.opacity(0.06))
            )
            .opacity(isRead ? 0.75 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

struct InboxNotificationRow_Previews: PreviewProvider {
    static var previews: some View {
        InboxNotificationRow(
            notification: UserNotificationDto.stubSecurityNotification()
        )
        .previewBox()
    }
}
