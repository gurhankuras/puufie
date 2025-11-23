//
//  RemoteLocalization.swift
//  puutie
//
//  Created by Gurhan on 11/21/25.
//

import Foundation

struct RemoteLocalization: Decodable {
    let version: Int
    let locale: String
    let strings: [String: String]
}

extension RemoteLocalization {
    func cacheData(at date: Date) -> LocalizationCacheData {
        return LocalizationCacheData(
            locale: locale,
            version: version,
            strings: strings,
            fetchedAt: date
        )
    }
}
