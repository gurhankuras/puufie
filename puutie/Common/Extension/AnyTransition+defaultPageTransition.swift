//
//  AnyTransition+defaultPageTransition.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

extension AnyTransition {
    static var defaultPageTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
