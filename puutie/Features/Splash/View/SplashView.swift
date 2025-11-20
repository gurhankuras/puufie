//
//  SplashView.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: NavigationRouter
    @EnvironmentObject var session: AppManager

    private var isVersionDialogPresented: Binding<Bool> {
        Binding(
            get: { session.versionDialogState.isPresented },
            set: { isPresented in
                if !isPresented {
                    session.versionDialogState = .none
                }
            }
        )
    }

    var body: some View {
        ZStack {
            Color.darkAccent2.ignoresSafeArea()
            Image(systemName: "skew")
                .imageScale(.large)
                .foregroundStyle(Color.white)
        }
        .customDialog(
            isPresented: isVersionDialogPresented,
            dismissible: false
        ) {
            dialogContent
        }
        .overlay(alignment: .bottomTrailing) {
            VersionText()
                .padding(12)
        }

        .task {
            await session.getVersion()
            if !session.versionDialogState.isPresented {
                session.evaluateAuth()
            }
        }
    }

    @ViewBuilder
    private var dialogContent: some View {
        switch session.versionDialogState {
        case .none:
            EmptyView()
        case .forceUpdate:
            CustomDialog(
                isPresented: isVersionDialogPresented,
                dismissible: false,
                message: "Force update required."
            ) {
                Button("Update") {
                    openAppStoreForUpdate()
                }
                .tint(.accent2)
                .font(.title2.weight(.medium))
                .buttonStyle(.borderedProminent)
            }

        case .error(let message):
            CustomDialog(
                isPresented: isVersionDialogPresented,
                dismissible: false,
                message: message
            ) {
                Button("Retry") {
                    Task {
                        await session.getVersion()
                    }
                }
                .tint(.accent2)
                .font(.title2.weight(.medium))
                .buttonStyle(.borderedProminent)
            }
        }
    }

    func openAppStoreForUpdate() {
        guard case .success(let res) = session.versionInfo,
            let appStoreLink = res.storeUrl
        else {
            print("Couldn't open the store link.")
            return
        }

        UIApplication.shared.openAppStore(for: appStoreLink)
    }

}
