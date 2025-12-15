//
//  RemoteUserNotificationService.swift
//  puutie
//
//  Created by Gurhan on 11/30/25.
//

protocol UserNotificationProvider {
    func getUserNotifications(page: Int, size: Int)
        async throws -> PagedResponse<UserNotificationDto>
}
