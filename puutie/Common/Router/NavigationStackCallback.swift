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
        HomeView(items: [])
    case .camera:
        CameraView()
    case .splash:
        SplashView()
    case .signUp:
        SignupView()
    case .accessControl:
        AccessControlView()
    case .permissions:
        PermissionsView()
    case .users:
        UsersListView(viewModel: UserListViewModel())
    case .profiles:
        ProfilesView()
    case .roles:
        RolesView()
    }
}



