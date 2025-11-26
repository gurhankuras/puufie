//
//  SummaryCard.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct SummaryCard: View {
    let totalUsers: Int
    let totalRoles: Int
    let pendingInvites: Int

    var body: some View {
        HStack(spacing: 14) {
            StatPill(title: "Users", value: "\(totalUsers)")
            StatPill(title: "Roles", value: "\(totalRoles)")
            StatPill(title: "Bekleyen", value: "\(pendingInvites)")
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 16, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.08))
        )
    }
}

struct SummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        SummaryCard(totalUsers: 20, totalRoles: 3, pendingInvites: 3)
            .previewBox()
    }
}
