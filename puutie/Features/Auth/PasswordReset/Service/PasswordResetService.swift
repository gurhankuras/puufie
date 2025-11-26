//
//  OtpService.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Foundation

public class PasswordResetService {

    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client
    }

    func requestForgotPassword(for username: String) async throws {
        let bodyRequest = OtpCreateRequest(username: username)
        var request = try PuutieAPI.ForgotPassword.request.post(
            body: .json(bodyRequest)
        )
        let _ = try await client.send(&request) as EmptyResponse
    }

    func resetPassword(with token: String, providing newPassword: String)
        async throws
    {
        let requestBody = PasswordResetRequest(token: token, newPassword: newPassword)
        var request = try PuutieAPI.ForgotPassword.reset.post(body: .json(requestBody))
        let _ = try await client.send(&request) as EmptyResponse
    }

    func verifyOtp(with requestBody: OtpVerificationRequest) async throws
        -> OtpVerificationResponse
    {
        var request = try PuutieAPI.ForgotPassword.verifyOtp.post(body: .json(requestBody))
        let response = try await client.send(&request) as OtpVerificationResponse
        return response
    }

}
