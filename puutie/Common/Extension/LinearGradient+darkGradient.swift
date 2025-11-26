//
//  LinearGradient+darkGradient.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import SwiftUI

extension LinearGradient {
    static var darkGradient: Self {
        return LinearGradient(
            colors: [
                Color.black, Color(red: 0.07, green: 0.09, blue: 0.15),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
