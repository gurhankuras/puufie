//
//  AvatarView2.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI

struct AvatarView: View {
    let initials: String?
    let url: URL?
    let size: CGSize
    
    init(initials: String?, url: URL?, size: CGSize = .init(width: 44, height: 44)) {
        self.initials = initials
        self.url = url
        self.size = size
    }
    var body: some View {
        ZStack {
            
            if let url {
                // iOS 17: AsyncImage yenilendi; basit kullanım
                AsyncImage(url: url) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.2))
                }
            }
            if let initials {
                Circle().fill(Color.blue.opacity(0.2))
                Text(initials).font(.system(size: size.width * 0.4, weight: .semibold))
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width / 2, height: size.height / 2)
                    .foregroundColor(.lightShade2)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(Circle())
        .overlay(Circle().stroke(.white.opacity(0.08)))
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(initials: "GF", url: nil)
            .previewBox()
    }
}
