//
//  NavigationStackCallback.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import SwiftUI

@ViewBuilder
func destination(for route: Route) -> some View {
    switch route {
    case .login:
        LoginView()
    case .home:
        HomeView()
    case .camera:
        CameraView()
    case .splash:
        SplashView()
    case .signUp:
        SignupView()
    }
    
}



