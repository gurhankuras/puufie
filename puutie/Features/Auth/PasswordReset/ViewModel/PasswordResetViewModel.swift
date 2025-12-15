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
class PasswordResetViewModel: ObservableObject, BaseViewModel {
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
        } catch {
            handleError(error, state: &status)
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
        } catch {
            handleError(error, state: &otpStatus)
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
        } catch {
            handleError(error, state: &resetStatus)
        }
    }
    
    func getLatestPasswordPolicy() async {
        policyStatus = .loading
        do {
            let policy = try await authService.getLatestPasswordPolicy()
            passwordRules = PasswordRule.rules(for: policy)
            policyStatus = .success(policy)
        } catch {
            handleError(error, state: &policyStatus)
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
