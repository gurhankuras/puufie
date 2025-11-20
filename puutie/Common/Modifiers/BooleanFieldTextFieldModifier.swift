//
//  BooleanFieldTextFieldModifier.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI


struct BooleanFocusTextFieldModifier: ViewModifier {
    var isFocused: FocusState<Bool>.Binding

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .foregroundStyle(.darkShade2)
            .background(Color.lightShade2)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused.wrappedValue = true
            }
    }
}

extension View {
    func booleanTextFieldStyle(isFocused: FocusState<Bool>.Binding) -> some View {
        modifier(BooleanFocusTextFieldModifier(isFocused: isFocused))
    }
}
