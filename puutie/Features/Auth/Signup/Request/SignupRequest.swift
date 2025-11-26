//
//  SignupRequest.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

struct SignupRequest: Encodable {
    let username: String
    let password: String
    let firstName: String
    let lastName: String
    let email: String
    let countryCode: String
    let phoneNumber: String
}
