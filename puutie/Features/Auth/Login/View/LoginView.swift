//
//  LoginView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

enum LoginFields: Hashable {
    case username
    case password
}

struct LoginView: View, KeyboardReadable {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appManager: AppManager

    @StateObject private var viewModel: LoginViewModel = AppContainer.shared
        .buildLoginViewModel()

    @FocusState private var focusedField: LoginFields?
    @State private var isForgotSheetOpen = false
    @State private var isKeyboardVisible: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.darkAccent2, .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                ScrollView {
                    VStack(spacing: 24) {
                        Spacer(minLength: 60)

                        // Card
                        VStack(alignment: .leading, spacing: 20) {
                            headerSection
                            avatarSection
                            usernameTextField
                            PasswordTextField(
                                text: $viewModel.password,
                                focusedField: $focusedField,
                                placeholder: "login.password.placeholder"
                            )
                            forgotPasswordLinkButton
                            signInButton
                            signUpButton
                        }
                        .customCard()
                        .padding(.horizontal, 24)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }

            }
            .overlay(alignment: .bottomTrailing) {
                VersionText()
                    .padding(12)
                    .opacity(isKeyboardVisible ? 0 : 1)
            }

            if case .loading = viewModel.state {
                LoadingView()
            }
        }
        .sheet(
            isPresented: $isForgotSheetOpen,
            content: {
                PasswordResetView(
                    username: $viewModel.username,
                    isPresented: $isForgotSheetOpen
                )
            }
        )
        .customDialog(isPresented: $viewModel.hasError) {
            CustomDialog(
                isPresented: $viewModel.hasError,
                message: viewModel.state.failureMessage
            )
        }
        .onChange(of: viewModel.state) { newValue in
            if case .success = newValue {
                appManager.didLogin()
            }
        }
        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
            isKeyboardVisible = newIsKeyboardVisible
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("login.title")  // "Giriş Yap" vs.
                .foregroundStyle(.lightShade2)
                .font(.title2.weight(.semibold))

            Text("login.subtitle")  // "Devam etmek için giriş yapın" gibi bir key ekleyebilirsin
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

    // MARK: - Fields & Buttons

    private var usernameTextField: some View {
        TextField(
            "",
            text: $viewModel.username,
            prompt: Text("login.username.placeholder")
                .foregroundColor(.lightAccent2)
        )
        .textContentType(.username)
        .appTextFieldStyle(
            field: .username,
            focusedField: $focusedField
        )
        .textInputAutocapitalization(.never)
        .focused($focusedField, equals: .username)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .password
        }
    }

    private var forgotPasswordLinkButton: some View {
        Button {
            isForgotSheetOpen = true
        } label: {
            Text("login.forgot_password")
                .foregroundStyle(.lightShade2)
                .font(.callout.weight(.semibold))
        }
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .contentShape(Rectangle())
    }

    private var signInButton: some View {
        Button("login.sign_in") {  // key’deki extra boşluğu sildim
            Task {
                try? await viewModel.login()
            }
        }
        .buttonStyle(LongButtonStyle())
        .padding(.top, 4)
    }

    private var signUpButton: some View {
        Button {
            router.push(.signUp)
        } label: {
            HStack(spacing: 4) {
                Text("login.new_user.title")  // "Hesabın yok mu?" gibi
                    .foregroundColor(.lightShade2)
                    .font(.callout)

                Text(message)  // "Sign Up" kısmı daha vurgulu
            }
        }
        .padding(.top, 6)
        .frame(maxWidth: .infinity, alignment: .center)
        .contentShape(Rectangle())
    }

    private var message: AttributedString {
        var result = AttributedString(
            NSLocalizedString("login.new_user.sign_up", comment: "")
        )
        result.font = .callout.bold()
        result.foregroundColor = .accent2
        return result
    }
}

#Preview {
    LoginView()
        .environment(\.locale, .init(identifier: "tr"))
}

#Preview {
    LoginView()
        .environment(\.locale, .init(identifier: "en"))

}
