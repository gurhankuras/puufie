//
//  ForgotMyPasswordView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct ForgotMyPasswordView: View {
    @Binding public var username: String
    @Binding public var isPresented: Bool
    @StateObject var viewModel: ForgotPasswordViewModel = AppContainer.shared.buildForgotPasswordViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            Color.darkAccent2.ignoresSafeArea()
            VStack {
                buildHeader()
                if viewModel.step == .form {
                    ForgotPasswordFormStepView(
                        username: $username,
                        viewModel: viewModel
                    )
                    .transition(
                        .move(edge: .leading).combined(
                            with: .opacity
                        )
                    )
                    .padding()

                }
                if viewModel.step == .otp {
                    ForgotPasswordOtpStepView(username: username, viewModel: viewModel)
                        .transition(
                            AnyTransition.move(edge: .trailing).combined(
                                with: .opacity
                            )
                        )
                        .padding()
                }
            }
            .animation(.easeOut, value: viewModel.step)
            .onChange(of: viewModel.status) { newValue in
                if case .success = newValue {
                       viewModel.step = .otp
                   }
            }
            .onChange(of: viewModel.otpStatus) { newValue in
                if viewModel.otpStatus == .success {
                    isPresented = false
                }
            }
            if viewModel.status == .loading {
                LoadingView()
            }
        }
        .dismissKeyboardOnTap()
    }

    func buildHeader() -> some View {
        HStack {
            Text("Forgot Your Password?")
                .font(.title2.weight(.medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.darkShade2.opacity(0.5))
        .overlay(alignment: .leading) {
            Button(action: onTapButton) {
                Image(
                    systemName: viewModel.step == .form
                        ? "xmark" : "arrow.left"
                )
                .padding()
                .imageScale(.large)
                .foregroundColor(Color.white)
                .containerShape(.rect)
                
            }
        }
    }

    func onTapButton() {
        if viewModel.step == .form {
            isPresented = false
        } else {
            viewModel.step = .form
        }
    }
}

struct ForgotMyPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.darkAccent2.ignoresSafeArea()
        }
        .sheet(isPresented: .constant(true)) {
            ForgotMyPasswordView(
                username: .constant("deneme"),
                isPresented: .constant(true)
            )
        }
    }
}
