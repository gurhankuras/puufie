//
//  TextFieldModifier.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct TextFieldModifier<Field: Hashable>: ViewModifier {
    let field: Field
    var focusedField: FocusState<Field?>.Binding

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .foregroundStyle(.darkShade2)
            .background(Color.lightShade2)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField.wrappedValue = field
            }
    }
}


extension View {
    func appTextFieldStyle<Field: Hashable>(
        field: Field,
        focusedField: FocusState<Field?>.Binding
    ) -> some View {
        modifier(TextFieldModifier(field: field, focusedField: focusedField))
    }
}
