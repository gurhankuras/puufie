//
//  VersionText.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI

struct VersionText: View {
    var body: some View {
        Text(versionText)
            .foregroundColor(.lightAccent2)
            .font(.caption)
    }
    
    private var versionText: String {
        guard let shortVersionText = Bundle.main.shortVersionString else {
            return ""
        }
        return "v\(shortVersionText)"
    }
}
