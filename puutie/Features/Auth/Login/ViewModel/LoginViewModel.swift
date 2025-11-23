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
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService

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
        do {
            let res = try await authService.login(username: username, password: password)
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
