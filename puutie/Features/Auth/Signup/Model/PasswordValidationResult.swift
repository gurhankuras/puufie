//
//  PasswordValidationResult.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//

import Foundation

struct PasswordValidationResult {
    let isValid: Bool
    let errors: [String]
    
    static func ok() -> PasswordValidationResult {
        .init(isValid: true, errors: [])
    }
    
    static func fail(_ errors: [String]) -> PasswordValidationResult {
        .init(isValid: false, errors: errors)
    }
}
