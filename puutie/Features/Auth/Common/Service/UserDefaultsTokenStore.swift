//
//  UserDefaultsTokenStore.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public final class UserDefaultsTokenStore: TokenPersisting {
    private let defaults: UserDefaults
    private let key: String
    
    public init(
        defaults: UserDefaults = .standard,
        key: String = "auth.access_token"
    ) {
        self.defaults = defaults
        self.key = key
    }
    
    public func load() -> String? { defaults.string(forKey: key) }
    
    public func save(_ token: String?) -> Bool {
        if let token {
            defaults.set(token, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
        return true
    }
    
    public func delete() -> Bool {
        defaults.removeObject(forKey: key)
        return true
    }
}
