//
//  LinearGradient+defaultGradient.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import SwiftUI

extension LinearGradient {
    static var appBackground: LinearGradient {
        LinearGradient(
            colors: [.darkAccent2, .black],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
