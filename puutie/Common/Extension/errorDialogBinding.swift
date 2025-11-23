//
//  errorDialogBinding.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI

func errorDialogBinding<T>(_ state: Binding<AsyncState<T, String>>) -> Binding<Bool> {
    Binding(
        get: {
            state.wrappedValue.errorMessage != nil
        },
        set: { isPresented in
            // Dialog kapandıysa error'u sıfırla
            if !isPresented {
                state.wrappedValue = .idle
            }
        }
    )
}
