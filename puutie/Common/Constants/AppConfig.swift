//
//  AppConfig.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

final class AppConfig {
    static let shared = AppConfig()

    private init() {}

    var environment: AppEnvironment = .dev

    var baseURL: String {
        switch environment {
        case .dev:
            return "http://localhost:8080"
        case .staging:
            return "http://192.168.1.103:8080"
        case .prod:
            return "https://api.example.com"
        }
    }
}
