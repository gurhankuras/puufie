//
//  Untitled.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Combine
import SwiftUI

enum PasswordResetStep {
    case form
    case otp
    case newPassword
}

@MainActor
class PasswordResetViewModel: ObservableObject {
    private let service: PasswordResetService
    private let authService: AuthService

    init(service: PasswordResetService, authService: AuthService) {
        self.service = service
        self.authService = authService
    }

    @Published var status: AsyncState<Empty, String> = .idle
    @Published var otpStatus: AsyncState<String, String> = .idle
    @Published var resetStatus: AsyncState<Empty, String> = .idle
    @Published var policyStatus: AsyncState<PasswordPolicy, String> = .idle
    @Published var passwordRules: [PasswordRule] = []
    

    @Published var step: PasswordResetStep = .form
    @Published var token: String?
    @Published var code: String = ""
    @Published var newPassword: String = ""

    func requestForgotPassword(for username: String) async {
        status = .loading
        do {
            try await service.requestForgotPassword(for: username)
            status = .success
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                status = .error(object?.message ?? "")
                return
            }
            status = .error("Something went wrong.")
        } catch {
            status = .error("Unexpected error.")
        }
    }

    func submitOtp(for username: String, otp: String) async {
        otpStatus = .loading
        do {
            let request = OtpVerificationRequest(
                username: username,
                code: otp,
                subject: "FORGOT_PASSWORD"
            )
            let response = try await service.verifyOtp(with: request)
            otpStatus = .success(response.token)
            token = response.token
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                otpStatus = .error(object?.message ?? "")
                return
            }
            otpStatus = .error("Something went wrong.")
        } catch {
            otpStatus = .error("Unexpected error.")
        }
    }

    func resetPassword(newPassword: String) async {
        guard let token = token else { return }
        
        resetStatus = .loading
        do {
            try await service.resetPassword(
                with: token,
                providing: newPassword
            )
            resetStatus = .success
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                resetStatus = .error(object?.message ?? "")
                return
            }
            resetStatus = .error("Something went wrong.")
        } catch {
            resetStatus = .error("Unexpected error.")
        }
    }
    
    func getLatestPasswordPolicy() async {
        policyStatus = .loading
        do {
            let policy = try await authService.getLatestPasswordPolicy()
            passwordRules = PasswordRule.rules(for: policy)
            policyStatus = .success(policy)
        } catch let apiError as APIError {
            if case .server(_, let object) = apiError {
                policyStatus = .error(object?.message ?? "")
                return
            }
            policyStatus = .error("Something went wrong.")
        } catch {
            policyStatus = .error("Unexpected error.")
        }
    }

    func handleCurrentStepAction(username: String) async {
        switch step {
        case .form:
            await requestForgotPassword(for: username)
        case .otp:
            await submitOtp(for: username, otp: code)
        case .newPassword:
            await resetPassword(newPassword: newPassword)
        }
    }
}
