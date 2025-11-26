//
//  RequestAuthorizing.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

public protocol RequestAuthorizing {
    func authorize(_ request: inout URLRequest)
}
