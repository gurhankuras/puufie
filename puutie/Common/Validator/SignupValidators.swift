//
//  SignupValidators.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//
import Foundation

enum SignupValidators {

    static func isValidEmail(_ email: String) -> Bool {
        let s = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return false }
        // Very lightweight RFC-ish check
        return s.range(
            of: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$",
            options: [.regularExpression, .caseInsensitive]
        ) != nil
    }

    static func isValidPhone(countryCode: String, phone: String) -> Bool {
        let cc = countryCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let p = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cc.hasPrefix("+") && cc.count <= 4 else { return false }
        // digits only for local number, 5–15 digits typical E.164 local lengths vary
        let digitsOnly =
            p.range(of: "^[0-9]{5,15}$", options: .regularExpression) != nil
        return !p.isEmpty && digitsOnly
    }

}
