//
//  KeychainTokenStore.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

public final class KeychainTokenStore: TokenPersisting {
    private let key: String
    
    init(key: String = "auth.access_token") {
        self.key = key
    }

    public func load() -> String? {
        return Keychain.standard.read(account: key)
    }
    
    public func save(_ token: String?) -> Bool {
        if let token = token {
            Keychain.standard.save(token, account: key)
        }
        else {
            Keychain.standard.delete(account: key)
        }
        return true
    }
    
    public func delete() -> Bool {
        return Keychain.standard.delete(account: key)
    }
    
    
}
