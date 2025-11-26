//
//  SessionManager.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import Combine
import Foundation

enum VersionDialogState: Equatable {
    case none
    case forceUpdate
    case error(String)

    var isPresented: Bool {
        self != .none
    }
}

@MainActor
final class AppFlowCoordinator: ObservableObject {
    @Published var phase: AppPhase = .splash
    @Published var versionDialogState: VersionDialogState = .none

    var versionInfo: AsyncState<RemoteAppVersionResponse, String> = .idle

    private let appVersionService: AppVersionService
    private let accessTokenProvider: AccessTokenProvider
    private let notificationCenter: NotificationCenter

    private var tokenObserver: NSObjectProtocol? 

    init(
        appVersionService: AppVersionService,
        accessTokenProvider: AccessTokenProvider,
        notificationCenter: NotificationCenter = .default

    ) {
        self.appVersionService = appVersionService
        self.accessTokenProvider = accessTokenProvider
        self.notificationCenter = notificationCenter
        startObservingAuth()
    }
    
    deinit {
        if let tokenObserver {
            notificationCenter.removeObserver(tokenObserver)
        }
    }

    func startObservingAuth() {
        guard tokenObserver == nil else { return }
        tokenObserver = notificationCenter.addObserver(
            forName: .accessTokenChanged,
            object: nil,
            queue: .main
        ) { [weak self] notif in
            let newToken = notif.object as? String
            Task { @MainActor [weak self] in
                self?.handleTokenChange(newToken)
            }
        }
    }

    private func handleTokenChange(_ token: String?) {
        if let token, !token.isEmpty {
            phase = .authenticated
        } else {
            phase = .unauthenticated
        }
    }


    func fetchVersionInfo() async {
        do {
            let info = try await appVersionService.getVersionInfo()
            self.versionInfo = .success(info)
            versionDialogState = info.forceUpdate ? .forceUpdate : .none
        } catch {
            self.versionInfo = .error(error.localizedDescription)
            versionDialogState = .error(
                String(localized: "version_check.error")
            )
        }
    }

    func checkAuthAndRoute() {
        if let token = accessTokenProvider.currentToken, !token.isEmpty {
            phase = .authenticated
        } else {
            phase = .unauthenticated
        }
    }

    func signOut() {
        accessTokenProvider.clear()
    }
}
