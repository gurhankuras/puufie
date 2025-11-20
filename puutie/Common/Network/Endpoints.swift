//
//  Endpoints.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//

import Foundation

enum Endpoints {
    enum auth {
        static let login = "/api/auth/login"
    }
    enum forgotPassword {
        static let verifyOtp = "/api/auth/forgot-password/verify-otp"
        static let request = "/api/auth/forgot-password/request"
    }
    
    enum appVersion {
        static let version = "/api/app-version"
    }
    
    static func url(_ path: String) -> URL {
        return URL(string: AppConfig.shared.baseURL + path)!
    }
}
