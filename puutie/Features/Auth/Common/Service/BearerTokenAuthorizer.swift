//
//  BearerTokenPersister.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public struct BearerTokenAuthorizer: RequestAuthorizing {
    private let provider: AccessTokenProvider
    
    public init(provider: AccessTokenProvider) {
        self.provider = provider
    }

    public func authorize(_ request: inout URLRequest) {
        if let token = provider.currentToken, !token.isEmpty {
            request.setValue(
                "Bearer \(token)",
                forHTTPHeaderField: "Authorization"
            )
        }
    }
}
