//
//  ForgotPasswordOtpStepView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct ForgotPasswordOtpStepView: View {
    let username: String
    @ObservedObject var viewModel: ForgotPasswordViewModel

    var body: some View {
        ZStack {
            Color.darkAccent2.ignoresSafeArea()
            OTPView { value in
                Task {
                    await viewModel.submitOtp(for: username, otp: value)

                }
            }
        }
        .errorDialog(state: $viewModel.otpStatus)
    }
}

struct ForgotPasswordOtpStepView_Previews: PreviewProvider {

    static var previews: some View {
        ForgotPasswordOtpStepView(
            username: "dummy",
            viewModel: AppContainer.shared.buildForgotPasswordViewModel()
        )
    }

}
