//
//  DrawerModifier.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct DrawerModifier<DrawerContent: View>: ViewModifier {
    @Binding var isOpen: Bool
    var edge: Edge = .trailing
    var widthRatio: CGFloat = 0.8
    var dimOpacity: Double = 0.3
    var animation: Animation = .spring(response: 0.35, dampingFraction: 0.85)
    @ViewBuilder var drawerContent: () -> DrawerContent

    func body(content: Content) -> some View {
        ZStack {
            content

            GeometryReader { proxy in
                let drawerWidth = proxy.size.width * widthRatio
                let offsetValue: CGFloat = isOpen ? 0 :
                    (edge == .trailing ? drawerWidth : -drawerWidth)

                // Dimmed background
                Color.black
                    .opacity(isOpen ? dimOpacity : 0)
                    .ignoresSafeArea()
                    .allowsHitTesting(isOpen)
                    .onTapGesture { toggle(false) }

                // Drawer
                HStack(spacing: 0) {
                    if edge == .leading { drawerBody(width: drawerWidth) }
                    Spacer(minLength: 0)
                    if edge == .trailing { drawerBody(width: drawerWidth) }
                }
                .offset(x: offsetValue)
                .animation(animation, value: isOpen)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            // basit swipe kapatma
                            let threshold: CGFloat = 60
                            if edge == .trailing, value.translation.width > threshold {
                                toggle(false)
                            } else if edge == .leading, value.translation.width < -threshold {
                                toggle(false)
                            }
                        }
                )
            }
        }
    }

    @ViewBuilder
    private func drawerBody(width: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack {
                if edge == .trailing {  Spacer() }
                Button {
                    toggle(false)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(12)
                        .contentShape(Rectangle())
                }
                if edge == .leading {  Spacer() }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)

            drawerContent()
                .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .frame(width: width)
        .background(Color(.sRGB, red: 18/255, green: 18/255, blue: 20/255, opacity: 1)) // senin darkAccent2 yerine
        .accessibilityAddTraits(.isModal)
    }

    private func toggle(_ value: Bool) {
        withAnimation(animation) { isOpen = value }
    }
}
