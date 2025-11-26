import Combine
//
//  SignupViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//
import Foundation

@MainActor
class SignupViewModel: ObservableObject {
    private let authService: AuthService
    private let validator: PasswordValidator

    init(authService: AuthService) {
        self.authService = authService
        self.validator = PasswordValidator()
        bindValidation()
    }

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var policyState: AsyncState<PasswordPolicy, String> = .idle
    @Published private(set) var latestPolicy: PasswordPolicy?
    @Published var state: AsyncState<String, String> = .idle
    @Published var passwordErrorMessages: [String] = []
    @Published private(set) var isPasswordValid: Bool = false
    var canProceeedToSignUp: Bool { isPasswordValid }


    private func bindValidation() {
        // no bounce for instant validation
        Publishers.CombineLatest($password.removeDuplicates(), $latestPolicy)
            .map { [unowned self] password, policy in
                guard let policy else { return false }
                return self.validator.validate(password, policy: policy).isValid
            }
            .receive(on: RunLoop.main)
            .assign(to: &$isPasswordValid)

        // debounce for messages
        Publishers.CombineLatest($password.removeDuplicates().dropFirst(), $latestPolicy)
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .map { [unowned self] password, policy in
                guard let policy else { return [] }
                return self.validator.validate(password, policy: policy).errors
            }
            .receive(on: RunLoop.main)
            .assign(to: &$passwordErrorMessages)
    }

    func getLatestPasswordPolicy() async {
        policyState = .loading

        do {
            let policy = try await authService.getLatestPasswordPolicy()
            latestPolicy = policy
            policyState = .success(policy)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                policyState = .error(object?.message ?? "")
                return
            }
            policyState = .error("Something went wrong.")
        } catch {
            policyState = .error("Unexpected error.")
        }
    }

    func signUp() async {
        guard canProceeedToSignUp else {
            state = .error("Lütfen şifre gereksinimlerini karşılayın.")
            return
        }
        state = .loading

        do {
            let res = try await authService.signUp(
                username: username,
                password: password
            )
            state = .success(res.accessToken)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                state = .error(object?.message ?? "")
                if let strings = object?.details?["errorMessages"]?.stringArray
                {
                    passwordErrorMessages = strings
                }
                return
            }
            state = .error("Something went wrong.")
        } catch {
            state = .error("Unexpected error.")
        }
    }

}
