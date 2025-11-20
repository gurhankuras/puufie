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
    let otpService: ForgotPasswordService
    let appVersionService: AppVersionService
    
    private init() {
        // 1) Ortak bağımlılıkları önce oluştur
        let client = NetworkClient()
        
        self.networkClient = client
        self.otpService = ForgotPasswordService(client: client)
        self.appVersionService = AppVersionService(client: client)
    }
    
    func buildLoginViewModel() -> LoginViewModel {
        return LoginViewModel(client: networkClient)
    }
    
    func buildForgotPasswordViewModel() -> ForgotPasswordViewModel {
        return ForgotPasswordViewModel(service: otpService)
    }
    
    func buildAppManager() -> AppManager {
        return AppManager(appVersionService: appVersionService)
    }
}

