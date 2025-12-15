//
//  UserNotificationService.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//

import Foundation
import UIKit

final class UserNotificationService: UserNotificationProvider {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func getUserNotifications(page: Int, size: Int)
        async throws -> PagedResponse<UserNotificationDto>
    {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "size", value: String(size)),
        ]
        var request = try PuutieAPI.PushNotification.userNotifications.get(
            queryItems: queryItems
        )
        let response: PagedResponse<UserNotificationDto> =
            try await client.send(&request)
        return response
    }
}
