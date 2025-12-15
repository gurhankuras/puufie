//
//  JWTTokenValidator.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//

import Foundation

enum JWTTokenValidator {
    /// Token validasyon sonucu
    enum ValidationResult {
        case valid
        case expired
        case invalid // Token formatı geçersiz, decode edilemez veya token yok
    }
    
    /// JWT token'ın expire olup olmadığını kontrol eder
    /// - Parameter token: Kontrol edilecek JWT token string'i
    /// - Returns: Token geçerliyse true, expire olmuşsa veya parse edilemezse false
    static func isTokenValid(_ token: String?) -> Bool {
        switch validateToken(token) {
        case .valid:
            return true
        case .expired, .invalid:
            return false
        }
    }
    
    /// JWT token'ı detaylı olarak validate eder
    /// - Parameter token: Kontrol edilecek JWT token string'i
    /// - Returns: Validation sonucu
    static func validateToken(_ token: String?) -> ValidationResult {
        guard let token = token, !token.isEmpty else {
            return .invalid
        }
        
        // JWT token formatı: header.payload.signature
        let components = token.components(separatedBy: ".")
        guard components.count == 3 else {
            return .invalid
        }
        
        // Payload'ı decode et (ikinci parça)
        let payload = components[1]
        
        // Base64URL decode
        guard let payloadData = base64URLDecode(payload),
              let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            // Token decode edilemez veya exp claim'i yoksa
            return .invalid
        }
        
        // exp Unix timestamp'i şu anki zamandan büyükse token geçerli
        let expirationDate = Date(timeIntervalSince1970: exp)
        return expirationDate > Date() ? .valid : .expired
    }
    
    /// Base64URL string'i decode eder
    private static func base64URLDecode(_ string: String) -> Data? {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Padding ekle
        let remainder = base64.count % 4
        if remainder > 0 {
            base64 += String(repeating: "=", count: 4 - remainder)
        }
        
        return Data(base64Encoded: base64)
    }
}

