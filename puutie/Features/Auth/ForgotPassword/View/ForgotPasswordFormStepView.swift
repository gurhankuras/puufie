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

    var body: some View {
        VStack(spacing: 20) {
            Text("forgot_password_description")
                .foregroundColor(.lightShade2)
                .font(.headline.weight(.medium))
                .padding(10)
            TextField(
                "",
                text: $username,
                prompt: Text("username_placeholder").foregroundColor(.lightAccent2)
            )
            .booleanTextFieldStyle(isFocused: $isFocused)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isFocused)
            
            Button("send_otp_button_title") {
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
