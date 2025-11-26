//
//  View+previewBox.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

extension View {
    public func previewBox() -> some View {
        self.padding()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
