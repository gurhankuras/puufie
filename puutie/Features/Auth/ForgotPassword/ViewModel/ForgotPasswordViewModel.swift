//
//  Untitled.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Combine
import SwiftUI


enum ForgotPasswordStep {
    case form
    case otp
}

@MainActor
class ForgotPasswordViewModel: ObservableObject {
    private let service: ForgotPasswordService

    init(service: ForgotPasswordService) {
        self.service = service
    }
    
    @Published var status: AsyncState<Empty> = .idle
    @Published var otpStatus: AsyncState<Empty> = .idle
    @Published var step: ForgotPasswordStep = .form

    func requestForgotPassword(for username: String) async {
        status = .loading
        // try? await Task.sleep(nanoseconds: 400_000_000_000)
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
        // try? await Task.sleep(nanoseconds: 400_000_000_000)
        do {
            let request = OtpVerificationRequest(
                username: username,
                code: otp,
                subject: "FORGOT_PASSWORD"
            )
            try await service.verifyOtp(with: request)
            otpStatus = .success
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
}
