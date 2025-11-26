//
//  User.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

struct LightUser: Decodable {
    let id: Int
    let username: String
    let email: String?
    let firstName: String?
    let lastName: String?
}
