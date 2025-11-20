//
//  LoginViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import Combine
import SwiftUI

enum LoginState: Equatable {
    case idle
    case loading
    case success(String)
    case failure(String)
}

extension LoginState {
    var failureMessage: String {
        if case .failure(let msg) = self {
            return msg
        }
        fatalError("State is not .failure")
    }
}

class LoginViewModel: ObservableObject {
    private let client: NetworkClientProtocol

    init(client: NetworkClientProtocol) {
        self.client = client

        $state
            .dropFirst()
            .map {
                if case .failure(_) = $0 { return true }
                else { return false }
            }
            .assign(to: &$hasError)
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var state: LoginState = .idle
    @Published var isValid: Bool = true
    @Published var hasError: Bool = false

    @MainActor
    func login() async throws {
        state = .loading
        let credentials = LoginCredentials(
            username: username,
            password: password
        )
        // guard let url = URL(string: "http://localhost:8080/api/auth/login")
        let url = Endpoints.url(Endpoints.auth.login)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let requestBody = try JSONEncoder().encode(credentials)
            request.httpBody = requestBody
            let res: LoginResponse = try await client.send(request)
            state = .success(res.accessToken)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                state = .failure(object?.message ?? "")
                return
            }
            state = .failure("Something went wrong.")
        } catch {
            state = .failure("Unexpected error.")
        }
    }

}
