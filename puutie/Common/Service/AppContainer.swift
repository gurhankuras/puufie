//
//  AppContainer.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

final class AppContainer {
    
    static let shared = AppContainer()   // 🔹 Singleton instansı

    // Public servisler (arayüz)
    let networkClient: NetworkClientProtocol
    let otpService: PasswordResetService
    let appVersionService: AppVersionService
    let authService: AuthService
    
    private init() {
        // 1) Ortak bağımlılıkları önce oluştur
        let client = NetworkClient()
        
        self.networkClient = client
        self.otpService = PasswordResetService(client: client)
        self.appVersionService = AppVersionService(client: client)
        self.authService = AuthService(client: client)
    }
    
    func buildLoginViewModel() -> LoginViewModel {
        return LoginViewModel(authService: authService)
    }
    
    func buildForgotPasswordViewModel() -> PasswordResetViewModel {
        return PasswordResetViewModel(service: otpService)
    }
    
    func buildAppManager() -> AppManager {
        return AppManager(appVersionService: appVersionService)
    }
    
    func buildSignupViewModel() -> SignupViewModel {
        return SignupViewModel(authService: authService)
    }
}

