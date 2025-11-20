//
//  View+errorDialog.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI

extension View {
    func errorDialog<T>(
        state: Binding<AsyncState<T>>,
        dismissible: Bool = true
    ) -> some View {
        self.customDialog(
            isPresented: errorDialogBinding(state),
            dismissible: dismissible
        ) {
            if let message = state.wrappedValue.errorMessage {
                CustomDialog(
                    isPresented: errorDialogBinding(state),
                    dismissible: dismissible,
                    message: message
                )
            }
        }
    }
}
