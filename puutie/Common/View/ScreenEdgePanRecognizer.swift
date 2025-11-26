//
//  ScreenEdgePanRecognizer.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import Foundation
import SwiftUI

struct ScreenEdgePanRecognizer: UIViewRepresentable {
    var edge: UIRectEdge
    var onOpen: () -> Void
    var threshold: CGFloat = 60

    func makeCoordinator() -> Coordinator {
        Coordinator(onOpen: onOpen, threshold: threshold, edge: edge)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let recognizer = UIScreenEdgePanGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handle(_:))
        )
        recognizer.edges = edge
        recognizer.cancelsTouchesInView = false      // jest tanınmadıkça alttaki dokunuşları iptal etme
        recognizer.requiresExclusiveTouchType = true // tanındığında tek başına kalsın
        view.addGestureRecognizer(recognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject {
        let onOpen: () -> Void
        let threshold: CGFloat
        let edge: UIRectEdge
        init(onOpen: @escaping () -> Void, threshold: CGFloat, edge: UIRectEdge)
        {
            self.onOpen = onOpen
            self.threshold = threshold
            self.edge = edge
        }

        @objc func handle(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)
            switch recognizer.state {
            case .ended:
                if edge == .right, translation.x <= -threshold { onOpen() }
                if edge == .left, translation.x >= threshold { onOpen() }
                default: break
            }
        }
    }
}
