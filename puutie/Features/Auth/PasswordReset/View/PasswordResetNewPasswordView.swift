//
//  PasswordResetNewPasswordView.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct PasswordResetNewPasswordView: View {
    @ObservedObject var viewModel: PasswordResetViewModel
    @Binding var newPassword: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PasswordRulesView(rules: viewModel.passwordRules)
            TextField(
                "",
                text: $newPassword,
                prompt: Text("reset_password.new_password.placeholder")
                    .foregroundColor(.lightAccent2)
            )
            .booleanTextFieldStyle(isFocused: $isFocused)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isFocused)
        }
        .padding()
        .focusOnAppear($isFocused)
    }
}
