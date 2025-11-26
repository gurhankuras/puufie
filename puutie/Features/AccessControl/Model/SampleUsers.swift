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
                id: 1,
                email: "ayse@acme.com",
                firstName: "Ayşe",
                lastName: "Yılmaz",
                username: "ayse",
            ),
            .init(
                id: 2,
                email: "mehmet@acme.com",
                firstName: "Mehmet",
                lastName: "Demir",
                username: "mehmetd",
            ),
            .init(
                id: 3,
                email: "guest@acme.com",
                firstName: "",
                lastName: "",
                username: "guest",
            ),
        ]
    }
}
