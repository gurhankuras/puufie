//
//  HomeView.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var flowCoordinator: AppFlowCoordinator
    @EnvironmentObject private var router: NavigationRouter
    
    @State private var isDrawerOpen = false

    @State var items: [StandardMenuItem]
    
    init(items: [StandardMenuItem]) {
        self.items = []
    }

    var body: some View {
        ZStack {
            LinearGradient.appBackground.ignoresSafeArea()
            VStack {
                header
                content
            }
        }
        .overlay(alignment: .trailing) {
            ScreenEdgePanRecognizer(
                edge: .right,
                onOpen: { isDrawerOpen = true }
            )
            .frame(width: 8)
            .background(Color.clear)
        }
        .drawer(
            isOpen: $isDrawerOpen,
            edge: .trailing,
            widthRatio: 0.75,
            dimOpacity: 0.3
        ) {
            SideMenuList(items: items) { _ in
                // bir item seçildiğinde drawer kapansın
                isDrawerOpen = false
                // burada navigation/flow tetikleyebilirsin
            }
        }
        .onAppear {
            items = [
                StandardMenuItem(systemImage: "", title: "", action: nil),
                StandardMenuItem(systemImage: "gear", title: "Settings", action: nil),
                StandardMenuItem(
                    systemImage: "person.3",
                    title: "Access Control",
                    action: {
                        self.router.push(.accessControl)
                    }
                ),
                
                StandardMenuItem(
                    systemImage: "rectangle.portrait.and.arrow.forward",
                    title: "Sign Out",
                    action: {
                        self.flowCoordinator.signOut()
                    }
                ),
            ]
        }
    }

    var header: some View {
        HStack {
            Spacer()
            Button {
                isDrawerOpen.toggle()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title.weight(.semibold))
                    .foregroundStyle(.lightShade2)
                    .padding()
                    .contentShape(Rectangle())
            }
        }
        .padding()
        .overlay {
            Text("Home").font(.title2).foregroundStyle(.white)
        }
    }

    var content: some View {
        ScrollView {
            ForEach(0..<10) { _ in
                Rectangle().fill(.accent2)
                    .aspectRatio(3 / 2, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .clipped()
                    .padding(.vertical, 20)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    static var previews: some View {
        HomeView(items: [])
    }
}
