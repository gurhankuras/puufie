//
//  ForgotPasswordFormStepView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct ForgotPasswordFormStepView: View {
    @Binding var username: String
    @ObservedObject var viewModel: ForgotPasswordViewModel
    @FocusState private var isFocused: Bool
    private let informationText = """
        We’re going to send a verification code to your email.

        Please enter the code to reset your password in the next step.

        This code is valid for 30 minutes.
        If you didn’t receive it, you can request a new one.
        """

    private var isErrorDialogPresented: Binding<Bool> {
        Binding(
            get: {
                if case .error(_) = viewModel.status {
                    return true
                }
                return false
            },
            set: { isPresented in
                if !isPresented {
                    viewModel.status = .idle
                }
            }
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(informationText)
                .foregroundColor(.lightShade2)
                .font(.headline.weight(.medium))
                .padding(10)
            TextField(
                "",
                text: $username,
                prompt: Text("Username").foregroundColor(.lightAccent2)
            )
            .booleanTextFieldStyle(isFocused: $isFocused)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isFocused)
            
            Button("Send OTP Code") {
                // viewModel.step = .otp
                Task {
                    await viewModel.requestForgotPassword(for: username)
                }
            }
            .buttonStyle(LongButtonStyle())
        }
        .customDialog(isPresented: isErrorDialogPresented) {
            CustomDialog(isPresented: isErrorDialogPresented, message: viewModel.status.errorMessage ?? "")
        }
        .onAppear {
            isFocused = true
        }
    }
}
