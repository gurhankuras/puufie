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

    init(service: PasswordResetService) {
        self.service = service
    }
    
    @Published var status: AsyncState<Empty, String> = .idle
    @Published var otpStatus: AsyncState<String, String> = .idle
    @Published var resetStatus: AsyncState<Empty, String> = .idle

    @Published var step: PasswordResetStep = .form
    @Published var token: String?
    @Published var code: String = ""
    @Published var newPassword: String = ""

    func requestForgotPassword(for username: String) async {
        status = .loading
        do {
            try await service.requestForgotPassword(for: username)
            status = .success
            step = .otp
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
            step = .newPassword
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
        if token == nil {
            return
        }
        status = .loading
        do {
            try await service.resetPassword(with: token!, providing: newPassword)
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
}
