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
    let userService: UserService
    let pushNotificationTokenService: PushNotificationTokenService
    let userNotificationservice: UserNotificationService

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
            requestAuthorizer: requestAuthorizer,
            onUnauthorized: { [weak accessTokenProvider] in
                // 401 hatası yakalandığında token'ı temizle
                // Bu, AppFlowCoordinator'ın notification'ı dinlemesiyle
                // otomatik olarak login ekranına yönlendirecek
                accessTokenProvider?.clear()
            }
        )

        self.networkClient = client
        self.otpService = PasswordResetService(client: client)
        self.appVersionService = AppVersionService(client: client)

        self.authService = AuthService(
            client: client,
            accessTokenProvider: accessTokenProvider
        )
        
        self.userService = UserService(client: networkClient)
        self.pushNotificationTokenService = PushNotificationTokenService(client: networkClient)
        self.userNotificationservice = UserNotificationService(client: networkClient)
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
            accessTokenProvider: accessTokenProvider,
            pushNotificationTokenService: pushNotificationTokenService
        )
    }

    func buildSignupViewModel() -> SignupViewModel {
        return SignupViewModel(authService: authService)
    }
    
    func buildUserListViewModel() -> UserListViewModel {
        return UserListViewModel(userService: userService)
    }
    
    func buildUserNotificationViewModel() -> UserNotificationsViewModel {
        return UserNotificationsViewModel(userNotificationProvider: MockUserNotificationService(simulatedDelay: 0.5))
    }
}
