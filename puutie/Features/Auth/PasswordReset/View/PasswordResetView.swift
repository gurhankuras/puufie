//
//  PasswordResetView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct PasswordResetView: View {
    @Binding public var username: String
    @Binding public var isPresented: Bool
    @StateObject var viewModel: PasswordResetViewModel = AppContainer.shared
        .buildForgotPasswordViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.darkAccent2.ignoresSafeArea()
            VStack(spacing: 0) {
                PasswordResetHeader(onClose: onTapButton)
                ScrollView {
                    VStack {
                        currentStepView
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .safeAreaInset(edge: .bottom) {
                PasswordResetBottomBar(
                    isDisabled: isPrimaryButtonDisabled,
                    title: primaryButtonTitle,
                    onTap: handlePrimaryAction
                )
            }
            if viewModel.status.isLoading || viewModel.otpStatus.isLoading || viewModel.resetStatus.isLoading {
                LoadingView()
            }
        }
     
        .dismissKeyboardOnTap()
        .errorDialog(state: $viewModel.otpStatus)
        .errorDialog(state: $viewModel.status)
        .errorDialog(state: $viewModel.resetStatus)
        .onChange(of: viewModel.status) { newValue in
            if case .success = newValue {
                withAnimation(.easeOut(duration: 0.25)) {
                    viewModel.step = .otp
                }
            }
        }
        .onChange(of: viewModel.otpStatus) { newValue in
            if case .success(let token) = newValue {
                viewModel.token = token
                withAnimation(.easeOut(duration: 0.25)) {
                    viewModel.step = .newPassword
                }
            }
        }
        .onChange(of: viewModel.resetStatus) { newValue in
            if case .success = newValue {
                isPresented = false
            }
        }

    }

    @ViewBuilder
    var currentStepView: some View {
        ZStack {
            if viewModel.step == .form {
                PasswordResetUsernameView(
                    username: $username,
                    viewModel: viewModel
                )
                .transition(.defaultPageTransition)
                .padding()
            }

            if viewModel.step == .otp {
                PasswordResetOtpStepView(
                    username: username,
                    viewModel: viewModel
                )
                .transition(.defaultPageTransition)
                .padding()
            }

            if viewModel.step == .newPassword {
                PasswordResetNewPasswordView(
                    viewModel: viewModel,
                    newPassword: $viewModel.newPassword
                )
                .transition(.defaultPageTransition)
                .padding()
            }
        }
    }


    var primaryButtonTitle: LocalizedStringKey {
        switch viewModel.step {
        case .form:
            return "reset_password.send_otp"  // Username step
        case .otp:
            return "reset_password.otp.verify"  // OTP step
        case .newPassword:
            return "reset_password.reset_button"  // New password step
        }
    }

    var isPrimaryButtonDisabled: Bool {
        switch viewModel.step {
        case .form:
            return username.isEmpty || viewModel.status == .loading
        case .otp:
            return viewModel.code.isEmpty || viewModel.otpStatus == .loading
        case .newPassword:
            return viewModel.newPassword.isEmpty
                || viewModel.resetStatus == .loading
        }
    }
    
    func handlePrimaryAction() {
        Task {
            await viewModel.handleCurrentStepAction(username: username)
        }
    }

    func onTapButton() {
        isPresented = false
    }
}


struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.darkAccent2.ignoresSafeArea()
        }
        .sheet(isPresented: .constant(true)) {
            PasswordResetView(
                username: .constant("deneme"),
                isPresented: .constant(true)
            )
        }
    }
}
