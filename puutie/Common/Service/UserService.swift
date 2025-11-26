//
//  UserService.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

class UserService {
    private let client: NetworkClientProtocol
    init(client: NetworkClientProtocol) {
        self.client = client
    }
    
    func getUsers() async throws  -> [LightUser]{
        var request = try PuutieAPI.User.root.get()
        let users: [LightUser] = try await client.send(&request)
        return users
    }
}
