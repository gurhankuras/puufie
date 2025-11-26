//
//  View+accessButton.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

extension View {
    func accessButton<S: StringProtocol>(
        _ title: S,
        @ViewBuilder perform action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
        }
    }
}

struct AccessButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .aspectRatio(1, contentMode: .fit)
            .background(
                (configuration.isPressed
                    ? Color.darkAccent2.opacity(0.7) : Color.darkAccent2),
                in: RoundedRectangle(cornerRadius: 15.0)
            )
            .shadow(
                color: .white.opacity(0.1),
                radius: 1,
                x: configuration.isPressed ? 2 : -1,
                y: configuration.isPressed ? 2 : -1
            )
            .scaleEffect(configuration.isPressed ? 0.86 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .foregroundColor(.white)

    }
}

/**

 Rectangle().fill(.darkAccent2)
     .clipShape(RoundedRectangle(cornerRadius: 15))
     .overlay {
         Button {

         } label: {
             VStack(spacing: 12) {
                 Image(systemName: term.imageIcon)
                     .font(.largeTitle)
                 Text(term.title)
                     .font(.title2)
             }
             .foregroundStyle(.white)
         }


     }
     .shadow(color: .white.opacity(0.1), radius: 2, x: 4, y: 4)

 **/
