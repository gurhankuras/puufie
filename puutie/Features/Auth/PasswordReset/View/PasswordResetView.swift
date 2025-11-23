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
                buildHeader()
                ScrollView {
                    VStack {
                        currentStepView
                    }
                }
                .animation(.easeIn, value: viewModel.step)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            if viewModel.status == .loading || viewModel.otpStatus == .loading || viewModel.resetStatus == .loading {
                LoadingView()
            }
        }
     
        .dismissKeyboardOnTap()
        .errorDialog(state: $viewModel.otpStatus)
        .errorDialog(state: $viewModel.status)
        .errorDialog(state: $viewModel.resetStatus)
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
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
                .padding()
            }

            if viewModel.step == .otp {
                PasswordResetOtpStepView(
                    username: username,
                    viewModel: viewModel
                )
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
                .padding()
            }

            if viewModel.step == .newPassword {
                PasswordResetNewPasswordView(
                    viewModel: viewModel,
                    newPassword: $viewModel.newPassword
                )
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
                .padding()
            }
        }
    }


    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.lightShade2.opacity(0.3))

            HStack {
                Button(action: handlePrimaryAction) {
                    Text(primaryButtonTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(LongButtonStyle())
                .grayscale(isPrimaryButtonDisabled ? 1 : 0)
                .opacity(isPrimaryButtonDisabled ? 0.6 : 1)
                .disabled(isPrimaryButtonDisabled)
            }
            .animation(.easeIn(duration: 0.2), value: isPrimaryButtonDisabled)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        // Sheet’in alt kısmını blur / material yapmak istersen:
        .background(.ultraThinMaterial)
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
        switch viewModel.step {
        case .form:
            Task {
                await viewModel.requestForgotPassword(for: username)
            }
        case .otp:
            Task {
                await viewModel.submitOtp(for: username, otp: viewModel.code)
            }
        case .newPassword:
            Task {
                await viewModel.resetPassword(
                    newPassword: viewModel.newPassword
                )
            }
        }
    }

    func buildHeader() -> some View {
        HStack {
            Text("reset_password.title")
                .font(.title2.weight(.medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.darkShade2.opacity(0.5))
        .overlay(alignment: .leading) {
            Button(action: onTapButton) {
                Image(
                    systemName: "xmark"
                )
                .padding()
                .imageScale(.large)
                .foregroundColor(Color.white)
                .containerShape(.rect)

            }
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
