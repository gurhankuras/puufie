//
//  RemoteAppVersion.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

struct RemoteAppVersionResponse: Codable {
    let platform: String
    let optionalUpdate: Bool
    let forceUpdate: Bool
    let latestVersion: String
    let storeUrl: String?
}
