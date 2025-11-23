//
//  LocalizationCacheService.swift
//  puutie
//
//  Created by Gurhan on 11/21/25.
//

import Foundation

final class LocalizationCacheService {
    static let shared = LocalizationCacheService()
    private init() {}

    private func cacheURL(for locale: String) -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("localization_cache_\(locale).json")
    }

    func save(_ cache: LocalizationCacheData, for locale: String) {
        let url = cacheURL(for: locale)
        do {
            let data = try JSONEncoder().encode(cache)
            try data.write(to: url, options: .atomic)
        } catch {
            print("⚠️ LocalizationCacheService.save error:", error)
        }
    }

    func load(for locale: String) -> LocalizationCacheData? {
        let url = cacheURL(for: locale)
        do {
            let data = try Data(contentsOf: url)
            let cache = try JSONDecoder().decode(LocalizationCacheData.self, from: data)
            return cache
        } catch {
            return nil
        }
    }

    func clear(locale: String) {
        let url = cacheURL(for: locale)
        try? FileManager.default.removeItem(at: url)
    }
}
