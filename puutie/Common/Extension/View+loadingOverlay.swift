//
//  View+loadingOverlay.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

extension View {
    /// Shows a `LoadingView` when `isPresented` is true.
    func loadingOverlay(isPresented: Bool) -> some View {
        ZStack {
            self
            if isPresented {
                LoadingView()
            }
        }
    }

    /// Shows a `LoadingView` if the given `AsyncState` is `.loading`
    func loadingOverlay<Success, Failure>(state: AsyncState<Success, Failure>) -> some View {
        self.loadingOverlay(isPresented: {
            if case .loading = state { return true }
            return false
        }())
    }
}
