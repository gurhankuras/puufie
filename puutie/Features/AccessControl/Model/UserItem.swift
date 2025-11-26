//
//  UserItem.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import Foundation

struct UserItem: Identifiable, Hashable {
    let id: UUID
    var email: String
    var firstName: String
    var lastName: String
    var username: String
    var isActive: Bool
    var avatarURL: URL? = nil

    var fullName: String { "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces) }
    var initials: String {
        let f = firstName.first.map(String.init) ?? ""
        let l = lastName.first.map(String.init) ?? ""
        return (f + l).uppercased()
    }
}
