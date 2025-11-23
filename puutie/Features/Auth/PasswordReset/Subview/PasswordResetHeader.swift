//
//  PasswordResetHeader.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import SwiftUI

struct PasswordResetHeader: View {
    let onClose: () -> Void

    var body: some View {
        HStack {
            Text("reset_password.title")
                .font(.title2.weight(.medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.darkShade2.opacity(0.5))
        .overlay(alignment: .leading) {
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .padding()
                    .imageScale(.large)
                    .foregroundColor(.white)
                    .containerShape(.rect)
            }
        }
    }
}
