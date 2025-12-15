//
//  RolesView.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct RolesView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Text("Roles")
            .navigationTitle("Roles")
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
