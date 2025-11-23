//
//  PasswordResetOtpStepView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct PasswordResetOtpStepView: View {
    let username: String
    @ObservedObject var viewModel: PasswordResetViewModel

    var body: some View {
        ZStack {
            Color.darkAccent2.ignoresSafeArea()
            OTPView(code: $viewModel.code)
        }
    }
}

struct ForgotPasswordOtpStepView_Previews: PreviewProvider {

    static var previews: some View {
        PasswordResetOtpStepView(
            username: "dummy",
            viewModel: AppContainer.shared.buildForgotPasswordViewModel()
        )
    }

}
