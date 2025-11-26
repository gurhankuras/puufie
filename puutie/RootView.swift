//
//  RootView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var router = NavigationRouter(paths: [])
    @StateObject private var session = AppContainer.shared.buildAppManager()

    var body: some View {
        ZStack {
            switch session.phase {

            case .unauthenticated:
                NavigationStack(path: $router.paths) {
                    LoginView()
                        .navigationBarBackButtonHidden(true)
                        .navigationDestination(
                            for: Route.self,
                            destination: destination(for:)
                        )
                }

            case .authenticated:
                NavigationStack(path: $router.paths) {
                    HomeView(items: [])
                        .navigationBarBackButtonHidden(true)  // root: Home
                        .navigationDestination(
                            for: Route.self,
                            destination: destination(for:)
                        )
                }
            case .splash:
                Color.appDarkAccent.ignoresSafeArea()
            }

            if session.phase == .splash {
                SplashView()
                    .environmentObject(session)
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .opacity.combined(with: .scale(scale: 1.1))
                        )
                    )
                    .zIndex(1)
            }
        }
        .environmentObject(router)
        .environmentObject(session)
        .preferredColorScheme(.dark)
        .animation(
            session.phase == .authenticated ? .none : .easeOut(duration: 0.45),
            value: session.phase
        )
        .dismissKeyboardOnTap()
    }
}
