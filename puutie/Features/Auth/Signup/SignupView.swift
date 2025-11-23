//
//  SignupView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//
import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel: SignupViewModel = AppContainer.shared
        .buildSignupViewModel()

    @EnvironmentObject var router: NavigationRouter

    @FocusState private var focusedField: LoginFields?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.darkAccent2, .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 40)

                        VStack(alignment: .leading, spacing: 20) {
                            headerSection
                            avatarSection
                            usernameTextField
                            PasswordTextField(
                                text: $viewModel.password,
                                focusedField: $focusedField,
                                placeholder: "login.password.placeholder"
                            )
                            errorMessages
                            signUpButton
                        }
                        .customCard()
                        .padding(.horizontal, 24)

                        Spacer(minLength: 20)
                    }
                    .frame(maxWidth: .infinity)
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .id("bottom")

        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("login.title")  // "Giriş Yap"
                    }
                    .foregroundColor(.lightShade2)
                }
            }
        }
      
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.getLatestPasswordPolicy()
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Sign Up")
                .font(.title2.weight(.semibold))
                .foregroundColor(.lightShade2)

            Text("Create your account to continue")
                .font(.subheadline)
                .foregroundColor(.lightAccent2)
        }
    }

    private var avatarSection: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.darkAccent2)
                    .frame(width: 80, height: 80)

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.lightShade2)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }

    private var usernameTextField: some View {
        TextField(
            "",
            text: $viewModel.username,
            prompt: Text("login.username.placeholder")
                .foregroundColor(.lightAccent2)
        )
        .textContentType(.username)
        .textInputAutocapitalization(.never)
        .focused($focusedField, equals: .username)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .password
        }
        .appTextFieldStyle(
            field: .username,
            focusedField: $focusedField
        )
    }

    private var signUpButton: some View {
        Button("sign_up.button.label") {
            Task {
                try? await viewModel.signUp()
            }
        }
        .buttonStyle(LongButtonStyle())
        .padding(.top, 8)
    }

    private var errorMessages: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !viewModel.passwordErrorMessages.isEmpty {
                if viewModel.passwordErrorMessages.count != 1 {
                    Text("Password must meet the following rules:")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.red.opacity(0.9))
                }

                ForEach(viewModel.passwordErrorMessages, id: \.self) { err in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                        Text(err)
                            .fixedSize(horizontal: false, vertical: true)

                    }
                    .font(.footnote)
                    .foregroundColor(.red.opacity(0.9))
                }
            }
        }
        .padding(.vertical, viewModel.passwordErrorMessages.isEmpty ? 0 : 8)
        .padding(.horizontal, viewModel.passwordErrorMessages.isEmpty ? 0 : 10)
        .background(
            Group {
                if !viewModel.passwordErrorMessages.isEmpty {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.red.opacity(0.08))
                }
            }
        )
        .animation(
            .easeInOut(duration: 0.25),
            value: viewModel.passwordErrorMessages.count
        )
    }
}

#Preview {
    SignupView()

}
