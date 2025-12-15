//
//  AuthService.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import Foundation
import UIKit

public class AuthService {
    
    private let client: NetworkClientProtocol
    private let accessTokenProvider: AccessTokenProvider
    init(client: NetworkClientProtocol, accessTokenProvider: AccessTokenProvider) {
        self.client = client
        self.accessTokenProvider = accessTokenProvider
    }
    
    func login(username: String, password: String) async throws -> LoginResponse {
        let credentials = LoginRequest(
            username: username,
            password: password,
            deviceName: UIDevice.current.name
        )
        var request = try PuutieAPI.Auth.login.post(body: .json(credentials))
        let res: LoginResponse = try await client.send(&request)
        accessTokenProvider.setToken(res.accessToken)
        return res
    }
    
    func signUp(with signUpRequest: SignupRequest) async throws -> SignupResponse {
        var request = try PuutieAPI.Auth.register.post(body: .json(signUpRequest))
        let res: SignupResponse = try await client.send(&request)
        accessTokenProvider.setToken(res.accessToken)
        return res
    }
    
    
    func getLatestPasswordPolicy() async throws -> PasswordPolicy{
        var request = try PuutieAPI.Auth.latestPasswordPolicy.get()
        let response = try await client.send(&request) as PasswordPolicy
        return response
    }
    
    
}
