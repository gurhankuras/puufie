//
//  AuthService.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import Foundation

public class AuthService {
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func login(username: String, password: String) async throws -> LoginResponse {
        let credentials = LoginCredentials(
            username: username,
            password: password
        )
        let url = Endpoints.url(Endpoints.auth.login)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = try JSONEncoder().encode(credentials)
        request.httpBody = requestBody
        let res: LoginResponse = try await client.send(request)
        return res
    }
    
    func signUp(username: String, password: String) async throws -> SignupResponse {
        let credentials = SignupRequest(
            username: username,
            password: password
        )
        let url = Endpoints.url(Endpoints.auth.register)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = try JSONEncoder().encode(credentials)
        request.httpBody = requestBody
        let res: SignupResponse = try await client.send(request)
        return res
    }
    
    
    func getLatestPasswordPolicy() async throws -> PasswordPolicy{
        let url = Endpoints.url(Endpoints.auth.latestPasswordPolicy)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"

        let response = try await client.send(request) as PasswordPolicy
        return response
    }
    
    
}
