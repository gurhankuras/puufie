//
//  UserRow.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI

struct UserRow: View {
    let user: UserItem

    var body: some View {
        HStack(spacing: 12) {
            AvatarView(
                initials: user.initials,
                url: user.avatarURL
            )
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(user.fullName.isEmpty ? "—" : user.fullName)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                }
                Text(user.email)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 14, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(.white.opacity(0.06))
        )
    }
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: SampleUsers.make().first!)
            .previewBox()
    }
}
