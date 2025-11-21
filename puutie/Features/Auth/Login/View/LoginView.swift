//
//  HomeView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

enum LoginFields: Hashable {
    case username
    case password
}

struct LoginView: View {
    
    @Environment(\.sizeCategory) var sizeCategory
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var appManager: AppManager

    @StateObject private var viewModel: LoginViewModel
    @State private var isForgotSheetOpen = false
    @FocusState private var focusedField: LoginFields?

    init() {
        _viewModel = StateObject(
            wrappedValue: AppContainer.shared.buildLoginViewModel()
        )
    }

    var body: some View {
        ZStack {
            Color.appDarkAccent.ignoresSafeArea()
            VStack {
                Text("login_title")
                    .foregroundStyle(.lightShade2)
                    .font(.title.weight(.semibold))
                usernameTextField
                passwordTextField
                forgotPasswordLinkButton
                signInButton
                signUpButton
            }
            .padding(20)

            if case .loading = viewModel.state {
                LoadingView()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VersionText()
                .padding(12)
        }
        .sheet(
            isPresented: $isForgotSheetOpen,
            content: {
                ForgotMyPasswordView(
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
        .onChange(
            of: viewModel.state,
            perform: { newValue in
                if case .success(_) = newValue {
                    appManager.didLogin()
                }
            }
        )
    }

    private var usernameTextField: some View {
        TextField(
            "",
            text: $viewModel.username,
            prompt: Text("username_placeholder").foregroundColor(.lightAccent2)
        )
        .textContentType(.username)
        .appTextFieldStyle(
            field: LoginFields.username,
            focusedField: $focusedField
        )
        .textInputAutocapitalization(.never)
        .padding(.bottom)
        .focused($focusedField, equals: LoginFields.username)
        .submitLabel(.next)
        .onSubmit {
            focusedField = .password
        }
    }

    private var passwordTextField: some View {
        SecureField(
            "",
            text: $viewModel.password,
            prompt: Text("password_placeholder").foregroundColor(.lightAccent2)
        )
        .textContentType(.password)
        .appTextFieldStyle(
            field: LoginFields.password,
            focusedField: $focusedField
        )
        .textInputAutocapitalization(.never)
        .focused($focusedField, equals: LoginFields.password)
        .submitLabel(.go)
    }

    private var forgotPasswordLinkButton: some View {
        Button {
            isForgotSheetOpen = true

        } label: {
            Text("forgot_password_button_title")
                .foregroundStyle(.lightShade2)
                .font(.callout)
                .fontWeight(.semibold)

        }
        .padding([.top, .leading, .bottom], 10)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private var signInButton: some View {
        Button("sign_in_button_title") {
            Task {
                try? await viewModel.login()
            }
        }
        .buttonStyle(LongButtonStyle())
    }

    private var signUpButton: some View {
        Button {
            router.push(.camera)
        } label: {
            Text("new_user_title")
                .foregroundColor(.lightShade2)
                .font(.callout.weight(.semibold))
            Text(message)

        }
        .padding([.top, .leading, .bottom], 10)
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private var message: AttributedString {
        var result = AttributedString(
               NSLocalizedString("new_user_sign_up_title", comment: "")
           )
        result.font = .callout.weight(.bold)
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
