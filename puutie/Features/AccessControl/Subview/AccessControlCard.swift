//
//  AccessControlCard.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct AccessControlCard: View {
    let item: AccessControlTerm
    let isPressed: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay {
                    LinearGradient(
                        colors: [.white.opacity(0.04), .white.opacity(0.01)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                    )
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 22).strokeBorder(
                        .white.opacity(0.08)
                    )
                }
                .shadow(radius: 12, y: 8)
                .scaleEffect(isPressed ? 0.98 : 1)

            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle().fill(item.tint.opacity(0.18)).frame(
                        width: 48,
                        height: 48
                    )
                    Image(systemName: item.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(item.tint)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title).font(.title3.weight(.semibold))
                    Text(item.subtitle).font(.footnote).foregroundStyle(
                        .secondary
                    )
                }
                Spacer()
            }
            .padding(16)
            .frame(minHeight: 140, maxHeight: 160)
            .foregroundStyle(.white)
        }
        .contentShape(RoundedRectangle(cornerRadius: 22))
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(12)
        }
        .animation(
            .spring(response: 0.25, dampingFraction: 0.85),
            value: isPressed
        )
    }
}

struct AccessControlCardModifier_Previews: PreviewProvider {
    static var previews: some View {
        AccessControlCard(
            item: .init(
                title: "Users",
                icon: "person.3.fill",
                tint: .blue,
                subtitle: "Yönet ve davet et"
            ) {

            },
            isPressed: false
        )
        .frame(width: 200, height: 200)
        .previewBox()
        
    }
}
