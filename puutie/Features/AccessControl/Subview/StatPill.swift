//
//  StatPill.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct StatPill: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.headline)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            .thinMaterial,
            in: RoundedRectangle(cornerRadius: 12, style: .continuous)
        )
    }
}

struct StatPill_Previews: PreviewProvider {
    static var previews: some View {
        StatPill(title: "Example", value: "Valuemeter")
            .previewBox()
    }
}
