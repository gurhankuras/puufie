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
        .errorDialog(state: $viewModel.status)
        .onAppear {
            isFocused = true
        }
    }
}
