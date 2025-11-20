//
//  DialogPresenter.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI

struct DialogPresenter<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder var dialog: () -> DialogContent
    let dismissible: Bool

    init(
        isPresented: Binding<Bool>,
        dismissible: Bool = true,
        @ViewBuilder dialog: @escaping () -> DialogContent
    ) {
        self._isPresented = isPresented
        self.dismissible = dismissible
        self.dialog = dialog
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            if dismissible {
                                isPresented = false
                            }
                        }
                    
                    // Üstteki dialog
                    dialog()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func customDialog<T: View>(
        isPresented: Binding<Bool>,
        dismissible: Bool = true,
        @ViewBuilder dialog: @escaping () -> T
    ) -> some View {
        self.modifier(
            DialogPresenter(
                isPresented: isPresented,
                dismissible: dismissible,
                dialog: { AnyView(dialog()) }
            )
        )
    }
}
