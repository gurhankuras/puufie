//
//  UserNotificationDto+stubs.swift
//  puutie
//
//  Created by Gurhan on 11/30/25.
//

import Foundation

extension UserNotificationDto {
    /// Returns a comprehensive list of stub notifications for testing
    static var stubs: [UserNotificationDto] {
        return [
            stubSecurityNotification(),
            stubReadNotification(),
            stubUnreadNotification(),
            stubSystemNotification(),
            stubEmptyTitleNotification()
        ]
    }
    
    /// Creates a security-related notification stub
    static func stubSecurityNotification(
        id: Int64 = 1,
        read: Bool = false
    ) -> UserNotificationDto {
        UserNotificationDto(
            id: id,
            title: "Hesabinizin sifresi degistirildi",
            body: "Eylemi gerceklestiren kisi siz degilseniz lutfen destege başvurun",
            category: "SECURITY",
            notificationType: "PASSWORD_CHANGED",
            target: "roles",
            read: read,
            readAt: read ? Date.now.addingTimeInterval(-3600) : nil,
            createdAt: Date.now.addingTimeInterval(-60000)
        )
    }
    
    /// Creates a read notification stub
    static func stubReadNotification(
        id: Int64 = 2
    ) -> UserNotificationDto {
        UserNotificationDto(
            id: id,
            title: "Yeni mesaj aldiniz",
            body: "Size yeni bir mesaj geldi",
            category: "MESSAGE",
            notificationType: "NEW_MESSAGE",
            target: "messages-page",
            read: true,
            readAt: Date.now.addingTimeInterval(-1800),
            createdAt: Date.now.addingTimeInterval(-7200)
        )
    }
    
    /// Creates an unread notification stub
    static func stubUnreadNotification(
        id: Int64 = 3
    ) -> UserNotificationDto {
        UserNotificationDto(
            id: id,
            title: "Yeni bildirim",
            body: "Bu bildirim henüz okunmadi",
            category: "GENERAL",
            notificationType: "INFO",
            target: nil,
            read: false,
            readAt: nil,
            createdAt: Date.now.addingTimeInterval(-300)
        )
    }
    
    /// Creates a system notification stub
    static func stubSystemNotification(
        id: Int64 = 4
    ) -> UserNotificationDto {
        UserNotificationDto(
            id: id,
            title: "Sistem guncellemesi",
            body: "Yeni ozellikler eklendi",
            category: "SYSTEM",
            notificationType: "UPDATE",
            target: "settings-page",
            read: false,
            readAt: nil,
            createdAt: Date.now.addingTimeInterval(-86400)
        )
    }
    
    /// Creates a notification with minimal data (edge case)
    static func stubEmptyTitleNotification(
        id: Int64 = 5
    ) -> UserNotificationDto {
        UserNotificationDto(
            id: id,
            title: nil,
            body: "Basliksiz bildirim",
            category: nil,
            notificationType: nil,
            target: nil,
            read: false,
            readAt: nil,
            createdAt: Date.now.addingTimeInterval(-120)
        )
    }
}
