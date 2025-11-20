//
//  ButtonStyle.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct LongButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(
                EdgeInsets(
                    top: 12,
                    leading: 20,
                    bottom: 12,
                    trailing: 20
                )
            )
            .foregroundStyle(.white)
            .font(.title3.weight(.medium))
            .frame(maxWidth: .infinity)
            .background(
                (configuration.isPressed
                    ? Color.accent2.opacity(0.7) : Color.accent2),
                in: Capsule()
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
