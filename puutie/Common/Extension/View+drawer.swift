//
//  View+drawer.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

public extension View {
    func drawer<Content: View>(
        isOpen: Binding<Bool>,
        edge: Edge = .trailing,
        widthRatio: CGFloat = 0.8,
        dimOpacity: Double = 0.3,
        animation: Animation = .spring(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(DrawerModifier(
            isOpen: isOpen,
            edge: edge,
            widthRatio: widthRatio,
            dimOpacity: dimOpacity,
            animation: animation,
            drawerContent: content
        ))
    }
}
