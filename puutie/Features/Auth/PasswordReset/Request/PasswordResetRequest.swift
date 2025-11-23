//
//  PasswordResetRequest.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

struct PasswordResetRequest: Encodable {
    let token: String
    let newPassword: String
}
