//
//  ProfilesView.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        Text("Profiles")
            .navigationTitle("Profiles")
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
