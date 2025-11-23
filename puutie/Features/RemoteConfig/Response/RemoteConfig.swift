//
//  RemoteConfig.swift
//  puutie
//
//  Created by Gurhan on 11/21/25.
//

import Foundation

struct RemoteConfig: Codable {
    let localizationVersion: Int
    let forceUpdateVersion: String?
    let featureFlags: [String: Bool]?
}
