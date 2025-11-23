//
//  RemoteLocalizationProvider.swift
//  puutie
//
//  Created by Gurhan on 11/21/25.
//

import Foundation

final class RemoteTextProvider {
    static let shared = RemoteTextProvider()

    private let cacheService = LocalizationCacheService.shared

    private(set) var activeLocale: String?
    private(set) var activeVersion: Int?
    private var texts: [String: String] = [:]

    private init() {}

    /// Telefonun diline göre kullanılacak locale’i aktifleştir
    func activate(locale: String) {
        self.activeLocale = locale

        if let cache = cacheService.load(for: locale) {
            self.activeVersion = cache.version
            self.texts = cache.strings
        } else {
            // Cache yok: texts boş
            self.activeVersion = nil
            self.texts = [:]
        }
    }

    /// Backend'ten gelen localization'ı güncelle ve cache'e yaz
    func update(with remote: RemoteLocalization) {
        let cache = LocalizationCacheData(
            locale: remote.locale,
            version: remote.version,
            strings: remote.strings,
            fetchedAt: Date()
        )

        cacheService.save(cache, for: remote.locale)

        if activeLocale == remote.locale {
            self.activeVersion = remote.version
            self.texts = remote.strings
        }
    }
}
