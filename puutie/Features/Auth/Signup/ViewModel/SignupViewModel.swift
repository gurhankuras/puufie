//
//  SignupViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//
import Foundation
import Combine

@MainActor
class SignupViewModel: ObservableObject {
    private let authService: AuthService
    private let validator: PasswordValidator

    init(authService: AuthService) {
        self.authService = authService
        self.validator = PasswordValidator()
        
       
        
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var policyState: AsyncState<PasswordPolicy, String> = .idle
    @Published var state: AsyncState<String, String> = .idle
    @Published var passwordErrorMessages: [String] = []
    
    
    
    @MainActor
    func getLatestPasswordPolicy() async {
        policyState = .loading
        
        do {
            let policy = try await authService.getLatestPasswordPolicy()
            $password
                .removeDuplicates()
                .dropFirst()
                .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
                .map { [unowned self] x in
                    return self.validator.validate(x, policy: policy)
                }
                .map { result in
                    return result.errors
                }
                .assign(to: &$passwordErrorMessages)
            
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

    @MainActor
    func signUp() async throws {
        state = .loading
        
        do {
            let res = try await authService.signUp(username: username, password: password)
            state = .success(res.accessToken)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                state = .error(object?.message ?? "")
                if let strings = object?.details?["errorMessages"]?.stringArray {
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
