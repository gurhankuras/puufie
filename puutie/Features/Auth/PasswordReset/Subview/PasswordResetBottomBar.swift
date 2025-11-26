//
//  PasswordResetBottomBar.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct PasswordResetBottomBar: View {
    let isDisabled: Bool
    let title: LocalizedStringKey
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.lightShade2.opacity(0.3))

            HStack {
                Button(action: onTap) {
                    Text(title)
                        .frame(maxWidth: .infinity)
                }
                .longButtonStyle(isDisabled: isDisabled)
            }
            .animation(.easeIn(duration: 0.2), value: isDisabled)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        .background(.ultraThinMaterial)
    }
}
