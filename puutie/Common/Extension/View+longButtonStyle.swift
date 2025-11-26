//
//  View+longButtonStyle.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI


extension View {
    func longButtonStyle(isDisabled: Bool = false) -> some View {
        self
            .buttonStyle(LongButtonStyle())
            .grayscale(isDisabled ? 1 : 0)
            .opacity(isDisabled ? 0.6 : 1)
            .disabled(isDisabled)
    }
}
