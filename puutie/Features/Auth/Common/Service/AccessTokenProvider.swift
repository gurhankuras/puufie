//
//  AccessTokenProvider.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

public protocol AccessTokenProvider: AnyObject {
    var currentToken: String? { get }
    func setToken(_ token: String?)
    func clear()
}
