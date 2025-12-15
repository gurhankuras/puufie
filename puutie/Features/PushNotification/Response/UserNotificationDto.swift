//
//  UserNotificationDto.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//

import Foundation

struct UserNotificationDto: Identifiable, Decodable {
    let id: Int64
    let title: String?
    let body: String?
    let category: String?
    let notificationType: String?
    let target: String?
    // let data: [String: JSONValue]?
    let read: Bool?
    let readAt: Date?
    let createdAt: Date?
}
