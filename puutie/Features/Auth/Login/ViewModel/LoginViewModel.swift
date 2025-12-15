//
//  LoginViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import Combine
import SwiftUI


class LoginViewModel: ObservableObject, BaseViewModel {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService

        $state
            .dropFirst()
            .map {
                if case .error(_) = $0 { return true }
                else { return false }
            }
            .assign(to: &$hasError)
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var state: AsyncState<String, String> = .idle
    @Published var isValid: Bool = true
    @Published var hasError: Bool = false
    

    @MainActor
    func login() async throws {
        state = .loading
        do {
            let res = try await authService.login(username: username, password: password)
            state = .success(res.accessToken)
        } catch {
            handleError(error, state: &state)
        }
    }

}
