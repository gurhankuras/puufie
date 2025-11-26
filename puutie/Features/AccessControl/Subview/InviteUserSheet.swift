//
//  InviteUserSheet.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI

struct InviteUserSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    var onInvite: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Kullanıcı Davet")
                .font(.headline)
            TextField("email@domain.com", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .padding(12)
                .background(
                    .thinMaterial,
                    in: RoundedRectangle(cornerRadius: 12)
                )
            HStack {
                Button("İptal") { dismiss() }
                Spacer()
                Button("Davet Gönder") {
                    guard !email.isEmpty else { return }
                    onInvite(email)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .foregroundStyle(.white)
        .background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.9),
                    Color(red: 0.07, green: 0.09, blue: 0.15),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
