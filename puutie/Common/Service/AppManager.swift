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
final class AppManager: ObservableObject {
    @Published var phase: AppPhase = .splash
    @Published var versionDialogState: VersionDialogState = .none

    var versionInfo: AsyncState<RemoteAppVersionResponse, String> = .idle

    private let appVersionService: AppVersionService

    init(appVersionService: AppVersionService) {
        self.appVersionService = appVersionService
    }

    func getVersion() async {
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

    func evaluateAuth() {
        // TODO:
        let hasValidToken = false
        if hasValidToken {
            phase = .authenticated
        } else {
            phase = .unauthenticated
        }
    }

    func didLogin() {
        phase = .authenticated
    }

    func didLogout() {
        phase = .unauthenticated
    }
}
