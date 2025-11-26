//
//  SampleUsers.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import Foundation

enum SampleUsers {
    static func make() -> [UserItem] {
        [
            .init(
                id: UUID(),
                email: "ayse@acme.com",
                firstName: "Ayşe",
                lastName: "Yılmaz",
                username: "ayse",
                isActive: true
            ),
            .init(
                id: UUID(),
                email: "mehmet@acme.com",
                firstName: "Mehmet",
                lastName: "Demir",
                username: "mehmetd",
                isActive: true
            ),
            .init(
                id: UUID(),
                email: "guest@acme.com",
                firstName: "",
                lastName: "",
                username: "guest",
                isActive: false
            ),
        ]
    }
}
