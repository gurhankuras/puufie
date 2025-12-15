//
//  LoginCredentials.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

struct LoginRequest: Encodable {
    let username: String
    let password: String
    let deviceName: String?
}
