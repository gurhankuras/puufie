//
//  PasswordPolicyErrorView.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct PasswordPolicyErrorView: View {
    let messages: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !messages.isEmpty {
                if messages.count != 1 {
                    Text("sign_up.password.rules.title")
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.red.opacity(0.9))
                }

                ForEach(messages, id: \.self) { err in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•")
                        Text(err)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .font(.footnote)
                    .foregroundColor(.red.opacity(0.9))
                }
            }
        }
        .padding(.vertical, messages.isEmpty ? 0 : 8)
        .padding(.horizontal, messages.isEmpty ? 0 : 10)
        .background(
            Group {
                if !messages.isEmpty {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.red.opacity(0.08))
                }
            }
        )
        .animation(.easeInOut(duration: 0.25), value: messages.count)
    }
}
