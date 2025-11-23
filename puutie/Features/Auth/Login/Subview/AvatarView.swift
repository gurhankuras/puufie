//
//  AvatarView.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct AvatarView: View {
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.darkAccent2)
                    .frame(width: 80, height: 80)

                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.lightShade2)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
