//
//  KeychainNamespace.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import CoreFoundation
import Security

public struct KeychainNamespace {
    public let service: String

    @discardableResult
    public func save(_ value: String,
                     account: String,
                     accessible: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) -> Bool {
        Keychain.save(value, service: service, account: account, accessible: accessible)
    }

    public func read(account: String) -> String? {
        Keychain.read(service: service, account: account)
    }

    @discardableResult
    public func delete(account: String) -> Bool {
        Keychain.delete(service: service, account: account)
    }
}
