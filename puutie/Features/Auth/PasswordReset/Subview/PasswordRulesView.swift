//
//  PasswordRulesView.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import SwiftUI

struct PasswordRulesView: View {
    let rules: [PasswordRule]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("sign_up.password.rules.title")
                .font(.headline.weight(.semibold))
                .foregroundColor(.lightShade2)
                .padding(.bottom, 8)

            ForEach(rules, id: \.self) { rule in
                HStack(alignment: .top, spacing: 6) {
                    Text("•")
                    Text(rule.localizedMessage)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .font(.headline.weight(.medium))
                .foregroundColor(.lightShade2)
            }
        }
        .padding(.vertical, rules.isEmpty ? 0 : 8)
        .padding(.horizontal, rules.isEmpty ? 0 : 8)
        .frame(maxWidth: .infinity)
        .background(
            Group {
                if !rules.isEmpty {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.blue.opacity(0.08))
                        .shadow(
                            color: .white.opacity(0.4),
                            radius: 1,
                            x: -1,
                            y: -1
                        )
                }
            }
        )
        .animation(.easeInOut(duration: 0.25), value: rules.count)
    }
}

struct PasswordRulesView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient.appBackground
            PasswordRulesView(
                rules: PasswordRule.rules(
                    for: PasswordPolicy(
                        minLength: 12,
                        maxLength: 30,
                        requireUpperCase: true,
                        requireLowerCase: true,
                        requireNumber: true,
                        requireSpecial: false,
                    )
                )
            )
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        }
      
    }
    
}
