//
//  AccessTokenManager.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public final class AccessTokenManager: AccessTokenProvider {
    private let store: TokenPersisting
    private var _token: String?
    
    private let queue = DispatchQueue(
        label: "auth.token.queue",
        attributes: .concurrent
    )

    public init(store: TokenPersisting) {
        self.store = store
        self._token = store.load()
    }

    public var currentToken: String? {
        var value: String?
        queue.sync { value = _token }
        return value
    }

    public func setToken(_ token: String?) {
        queue.async(flags: .barrier) { self._token = token }
        _ = store.save(token)
        NotificationCenter.default.post(
            name: .accessTokenChanged,
            object: token
        )
    }

    public func clear() {
        queue.async(flags: .barrier) { self._token = nil }
        _ = store.delete()
        NotificationCenter.default.post(name: .accessTokenChanged, object: nil)
    }
}
