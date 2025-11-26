//
//  ScaleHapticButtonStyle.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct ScaleHapticButtonStyle: ButtonStyle {
    let scale: CGFloat = 0.98
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .onChange(of: configuration.isPressed) { pressed in
                if pressed {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: configuration.isPressed)
    }
}
