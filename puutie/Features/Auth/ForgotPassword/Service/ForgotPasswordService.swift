//
//  OtpService.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Foundation

public class ForgotPasswordService {
    
    private let client: NetworkClientProtocol
    
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func requestForgotPassword(for username: String) async throws {
        let requestBody = try JSONEncoder().encode(OtpCreateRequest(username: username))
        let url = Endpoints.url(Endpoints.forgotPassword.request)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let _ = try await client.send(request) as EmptyResponse
    }
    
    func verifyOtp(with request: OtpVerificationRequest) async throws {
        let requestBody = try JSONEncoder().encode(request)
        let url = Endpoints.url(Endpoints.forgotPassword.verifyOtp)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = requestBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let _ = try await client.send(request) as EmptyResponse
    }
    
    
}
