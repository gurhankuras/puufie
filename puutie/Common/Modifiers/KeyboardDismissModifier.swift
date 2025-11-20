//
//  KeyboardDismissModifier.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//
import SwiftUI

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Rectangle()) // gesture'ın her yerde çalışmasını garantiler
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }
}
