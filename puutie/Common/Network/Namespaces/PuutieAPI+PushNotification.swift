//
//  PuutieAPI+PushNotification.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//
// /api/push-notification
public extension PuutieAPI.Endpoint where NS == PuutieAPI.PushNotificationNS {
    static let userNotifications = Self(["user-notification"])
    static func markRead(_ id: String) -> Self { .segments(id, "mark-read") }
    static let markAllRead = Self(["markAllRead"])
}
