//
//  NavigationRouter.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import Foundation
import SwiftUI
import Combine

class NavigationRouter: ObservableObject {
    @Published var path: [Route] = []

    func push(_ route: Route) {
        path.append(route)
    }

    func setPath(_ routes: [Route]) {
        path = routes
    }

    func pop() {
        _ = path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}

