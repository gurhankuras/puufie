import SwiftUI
struct DialogPresenter<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let dismissible: Bool
    @ViewBuilder let dialog: () -> DialogContent

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                // Tam ekran / tam sheet alanını dimleyen katman
                Color.black.opacity(0.45)
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if dismissible {
                            isPresented = false
                        }
                    }
                    .transition(.opacity)

                // Ortadaki dialog (CustomDialog burada)
                dialog()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: isPresented)
    }
}

extension View {
    func customDialog<DialogContent: View>(
        isPresented: Binding<Bool>,
        dismissible: Bool = true,
        @ViewBuilder dialog: @escaping () -> DialogContent
    ) -> some View {
        modifier(
            DialogPresenter(
                isPresented: isPresented,
                dismissible: dismissible,
                dialog: dialog
            )
        )
    }
}
