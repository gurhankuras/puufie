//
//  SessionManager.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import Combine
import FirebaseMessaging
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
    private let pushNotificationTokenService: PushNotificationTokenService

    private var tokenObserver: NSObjectProtocol?

    init(
        appVersionService: AppVersionService,
        accessTokenProvider: AccessTokenProvider,
        pushNotificationTokenService: PushNotificationTokenService,
        notificationCenter: NotificationCenter = .default

    ) {
        self.appVersionService = appVersionService
        self.accessTokenProvider = accessTokenProvider
        self.pushNotificationTokenService = pushNotificationTokenService
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
        if JWTTokenValidator.isTokenValid(token) {
            phase = .authenticated
            if let currentFcmToken = Messaging.messaging().fcmToken {
                pushNotificationTokenService.register(
                    with: currentFcmToken
                ) { _ in }
            }
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
        let token = accessTokenProvider.currentToken
        
        guard let token = token, !token.isEmpty else {
            phase = .unauthenticated
            return
        }
        
        // Token'ı validate et
        let validationResult = JWTTokenValidator.validateToken(token)
        
        switch validationResult {
        case .valid:
            // Token geçerli, authenticated olarak devam et
            phase = .authenticated
            
        case .invalid, .expired:
            // Token formatı geçersiz veya expire olmuş, temizle ve login ekranına yönlendir
            accessTokenProvider.clear()
            phase = .unauthenticated
        }
    }

    func signOut() {
        accessTokenProvider.clear()
    }
}
