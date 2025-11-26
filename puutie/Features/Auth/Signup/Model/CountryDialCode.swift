//
//  CountryDialCode.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

struct CountryDialCode: Identifiable, Hashable {
    let regionCode: String  // ISO 3166-1 alpha-2 (e.g., "TR")
    let name: String  // Localized display name (fallback provided)
    let dialCode: String  // e.g., "+90"

    var id: String { regionCode }

    var flagEmoji: String {
        // Convert region code to regional indicator symbols 🇹🇷
        let base: UInt32 = 127397
        return regionCode.uppercased().unicodeScalars.compactMap {
            UnicodeScalar(base + $0.value)
        }.map { String($0) }.joined()
    }
}

// Minimal curated list (expand as needed)
extension CountryDialCode {
    static let all: [CountryDialCode] = [
        .init(regionCode: "TR", name: "Türkiye", dialCode: "+90"),
        .init(regionCode: "US", name: "United States", dialCode: "+1"),
        .init(regionCode: "GB", name: "United Kingdom", dialCode: "+44"),
        .init(regionCode: "DE", name: "Deutschland", dialCode: "+49"),
        .init(regionCode: "FR", name: "France", dialCode: "+33"),
        .init(regionCode: "IT", name: "Italia", dialCode: "+39"),
        .init(regionCode: "ES", name: "España", dialCode: "+34"),
        .init(regionCode: "NL", name: "Nederland", dialCode: "+31"),
        .init(regionCode: "AE", name: "UAE", dialCode: "+971"),
        .init(regionCode: "SA", name: "Saudi Arabia", dialCode: "+966"),
    ].sorted { $0.name < $1.name }
}
