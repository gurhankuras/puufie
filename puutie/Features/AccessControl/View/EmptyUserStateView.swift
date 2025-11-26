//
//  EmptyUserStateView.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI


// MARK: - Empty
struct EmptyStateView: View {
    @Binding var query: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3")
                .font(.system(size: 44, weight: .semibold))
            Text("Kullanıcı bulunamadı")
                .font(.headline)
            Text("Arama teriminizi değiştirin veya filtreleri gevşetin.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            HStack {
                Button("Filtreleri Temizle") {
                    query = ""
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(24)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.08))
        )
        .foregroundStyle(.white)
    }
}
