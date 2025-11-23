//
//  View+focusOnAppear.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

extension View {
    func focusOnAppear(_ focusState: FocusState<Bool>.Binding) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                focusState.wrappedValue = true
            }
        }
    }
}
