//
//  JsonDecoder+iso.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//

import Foundation

func makeJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()

    decoder.dateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        // Fractional seconds (microsecond) destekleyen formatter
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = formatter.date(from: dateString) {
            return date
        }

        // Buraya düşerse tarih formatı uyumsuz demektir
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Geçersiz ISO8601 tarih: \(dateString)"
        )
    }

    return decoder
}

