//
//  PasswordResetUsernameView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct PasswordResetUsernameView: View {
    @Binding var username: String
    @ObservedObject var viewModel: PasswordResetViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("reset_password.description")
                .foregroundColor(.lightShade2)
                .font(.headline.weight(.medium))
                .padding(10)
            TextField(
                "",
                text: $username,
                prompt: Text("login.username.placeholder").foregroundColor(.lightAccent2)
            )
            .booleanTextFieldStyle(isFocused: $isFocused)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .focused($isFocused)
        }
        .onAppear {
            isFocused = true
        }
    }
}
