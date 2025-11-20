//
//  View+.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

extension View {
    func crispyShadow(color: Color = .black.opacity(0.3)) -> some View {
        return self.shadow(
            color: color,
            radius: 0,
            x: 1,
            y: 1
        )
        .shadow(
            color: color,
            radius: 0,
            x: -1,
            y: 1
        )
        .shadow(
            color: color,
            radius: 0,
            x: 1,
            y: -1
        )
        .shadow(
            color: color,
            radius: 0,
            x: -1,
            y: -1
        )
    }

}
