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
    @EnvironmentObject var appManager: AppFlowCoordinator

    @EnvironmentObject var router: NavigationRouter

    @FocusState private var focusedField: LoginFields?

    var body: some View {
        ZStack {
            LinearGradient.appBackground
            .ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 40)

                        VStack(alignment: .leading, spacing: 20) {
                            headerSection
                            AvatarView()
                            usernameTextField
                            PasswordTextField(
                                text: $viewModel.password,
                                focusedField: $focusedField,
                                placeholder: "login.password.placeholder"
                            )
                            PasswordPolicyErrorView(
                                messages: viewModel.passwordErrorMessages
                            )
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
        .errorDialog(state: $viewModel.state)
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.state) { newValue in
            if case .success(_) = newValue {
                appManager.checkAuthAndRoute()
                router.pop()
            }
        }
        .task {
            await viewModel.getLatestPasswordPolicy()
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("login.new_user.sign_up")
                .font(.title2.weight(.semibold))
                .foregroundColor(.lightShade2)

            Text("sign_up.subtitle")
                .font(.subheadline)
                .foregroundColor(.lightAccent2)
        }
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
                await viewModel.signUp()
            }
        }
        .padding(.top, 8)
        .longButtonStyle(isDisabled: !viewModel.canProceeedToSignUp)

    }
}

#Preview {
    SignupView()

}
