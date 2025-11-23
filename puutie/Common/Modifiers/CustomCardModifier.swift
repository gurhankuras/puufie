//
//  CustomCardModifier.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI


struct CustomCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.darkShade2.opacity(0.95))
            )
            .shadow(radius: 18, y: 8)
    }
}


extension View {
    func customCard() -> some View {
        self.modifier(CustomCardModifier())
    }
}
