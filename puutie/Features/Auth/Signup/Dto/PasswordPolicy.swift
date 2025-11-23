//
//  PasswordPolicy.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

struct PasswordPolicy: Decodable {
    let minLength: Int
    let maxLength: Int
    let requireUpperCase: Bool
    let requireLowerCase: Bool
    let requireNumber: Bool
    let requireSpecial: Bool
}
