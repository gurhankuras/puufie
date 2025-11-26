//
//  AppContainer.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Foundation

final class AppContainer {

    static let shared = AppContainer()  // 🔹 Singleton instansı

    // Public servisler (arayüz)
    let networkClient: NetworkClientProtocol
    let otpService: PasswordResetService
    let appVersionService: AppVersionService
    let authService: AuthService
    let accessTokenProvider: AccessTokenProvider
    let requestAuthorizer: RequestAuthorizing

    private init() {
        // 1) Ortak bağımlılıkları önce oluştur
        KeychainConfig.environmentSuffix = AppEnvironment.staging.rawValue

        self.accessTokenProvider = AccessTokenManager(
            store: KeychainTokenStore()
        )
        self.requestAuthorizer = BearerTokenAuthorizer(
            provider: accessTokenProvider
        )
        let client = NetworkClient(
            urlSession: URLSession.shared,
            requestAuthorizer: requestAuthorizer
        )

        self.networkClient = client
        self.otpService = PasswordResetService(client: client)
        self.appVersionService = AppVersionService(client: client)

        self.authService = AuthService(
            client: client,
            accessTokenProvider: accessTokenProvider
        )

    }

    func buildLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }

    func buildForgotPasswordViewModel() -> PasswordResetViewModel {
        return PasswordResetViewModel(
            service: otpService,
            authService: authService
        )
    }

    func buildAppManager() -> AppFlowCoordinator {
        return AppFlowCoordinator(
            appVersionService: appVersionService,
            accessTokenProvider: accessTokenProvider
        )
    }

    func buildSignupViewModel() -> SignupViewModel {
        return SignupViewModel(authService: authService)
    }
}
