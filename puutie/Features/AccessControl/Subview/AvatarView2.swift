//
//  AvatarView2.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI

struct AvatarView2: View {
    let initials: String
    let url: URL?
    var body: some View {
        ZStack {
            if let url {
                // iOS 17: AsyncImage yenilendi; basit kullanım
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
            } else {
                Circle().fill(Color.blue.opacity(0.2))
                Text(initials).font(.callout.weight(.semibold))
            }
        }
        .frame(width: 44, height: 44)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white.opacity(0.08)))
    }
}
