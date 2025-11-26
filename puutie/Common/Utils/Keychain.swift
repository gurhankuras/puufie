//
//  Keychain.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public enum Keychain {
    public static let standard = KeychainNamespace(service: KeychainConfig.service)

    @discardableResult
    static func save(_ value: String,
                     service: String,
                     account: String,
                     accessible: CFString = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly) -> Bool {
        let data = Data(value.utf8)
        let add: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrAccessible: accessible,
            kSecValueData: data
        ]
        let status = SecItemAdd(add as CFDictionary, nil)
        if status == errSecSuccess { return true }
        if status == errSecDuplicateItem {
            let search: [CFString: Any] = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: account
            ]
            let update: [CFString: Any] = [
                kSecValueData: data,
                kSecAttrAccessible: accessible
            ]
            return SecItemUpdate(search as CFDictionary, update as CFDictionary) == errSecSuccess
        }
        return false
    }

    static func read(service: String, account: String) -> String? {
        let q: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(q as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
        return value
    }

    @discardableResult
    static func delete(service: String, account: String) -> Bool {
        let q: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        let status = SecItemDelete(q as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
