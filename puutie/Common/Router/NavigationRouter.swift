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
    
    init(paths: [Route]) {
        self.paths = paths
    }
    
    @Published var paths: [Route]

    func push(_ route: Route) {
        paths.append(route)
    }

    func setPath(_ routes: [Route]) {
        paths = routes
    }

    func pop() {
        _ = paths.popLast()
    }

    func popToRoot() {
        paths.removeAll()
    }
}

