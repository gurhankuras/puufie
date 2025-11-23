//
//  LozalizationConfigData.swift
//  puutie
//
//  Created by Gurhan on 11/21/25.
//

import Foundation

struct LocalizationCacheData: Codable {
    let locale: String
    let version: Int
    let strings: [String: String]
    let fetchedAt: Date
}
