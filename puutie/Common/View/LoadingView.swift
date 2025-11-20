//
//  LoadingView.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            ProgressView()
        }
    }
}

