//
//  KeychainConfig.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public enum KeychainConfig {
    /// Varsayılan service: com.company.app (yoksa "app")
    public static var defaultService: String {
        Bundle.main.bundleIdentifier ?? "app"
    }
    public static var environmentSuffix: String? = nil

    public static var service: String {
        if let suffix = environmentSuffix, !suffix.isEmpty {
            return defaultService + suffix
        }
        return defaultService
    }
}
