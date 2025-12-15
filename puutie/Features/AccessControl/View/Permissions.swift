//
//  Permissions.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Text("Permissions")
            .navigationTitle("Permissions")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.pop()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
    }
}
