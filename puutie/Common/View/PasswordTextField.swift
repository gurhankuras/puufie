//
//  PasswordTextField.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct PasswordTextField: View {
    @Binding var text: String
    var focusedField: FocusState<LoginFields?>.Binding
    
    let placeholder: LocalizedStringKey
    
    @State private var isVisible = false
    
    var body: some View {
        HStack {
            Group {
                if isVisible {
                    TextField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(.lightAccent2)
                    )
                } else {
                    SecureField(
                        "",
                        text: $text,
                        prompt: Text(placeholder)
                            .foregroundColor(.lightAccent2)
                    )
                }
            }
            .textContentType(.password)
            .textInputAutocapitalization(.never)
            .focused(focusedField, equals: .password)
            .submitLabel(.go)

            Button {
                isVisible.toggle()
            } label: {
                Image(systemName: isVisible ? "eye" : "eye.slash")
                    .foregroundColor(isVisible ? .darkAccent2.opacity(0.8) : .lightAccent2)
            }
            .buttonStyle(.plain)
        }
        .appTextFieldStyle(
            field: .password,
            focusedField: focusedField
        )
    }
}
