//
//  PushNotificationTokenService.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//

import Foundation
import UIKit

final class PushNotificationTokenService {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    public func register(
        with token: String,
        completion: @escaping (Result<EmptyResponse, APIError>) -> Void
    ) {
        let appVersion = Bundle.main.shortVersionString ?? "0.0.0"
        let osVersion = UIDevice.current.systemVersion
        let platform = "IOS"
        let request = RegisterPushTokenRequest(
            token: token,
            platform: platform,
            osVersion: osVersion,
            appVersion: appVersion
        )

        let url = PuutieAPI.PushNotificationToken.register.url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        urlRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        client.send(urlRequest, completion: completion)
    }
}
