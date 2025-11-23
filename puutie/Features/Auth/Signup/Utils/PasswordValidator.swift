//
//  PasswordValidator.swift
//  puutie
//
//  Created by Gurhan on 11/23/25.
//


// Java'daki PasswordValidator sınıfının Swift versiyonu
import Foundation
final class PasswordValidator {
    
    func validate(_ rawPassword: String?, policy: PasswordPolicy) -> PasswordValidationResult {
        var errors: [String] = []
        
        // 1) Null / boş kontrolü
        let password = rawPassword?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if password.isEmpty {
            let message = NSLocalizedString("sign_up.password_validation.empty", comment: "")
            errors.append(message)
            return .fail(errors)
        }
        
        // 2) Min / max length
        if password.count < policy.minLength {
            let format = NSLocalizedString("sign_up.password_validation.min_length", comment: "")
            let message = String(format: format, policy.minLength)
            errors.append(message)
            return .fail(errors)
        }
        
        if password.count > policy.maxLength {
            let format = NSLocalizedString("sign_up.password_validation.max_length", comment: "")
            let message = String(format: format, policy.maxLength)
            errors.append(message)
            return .fail(errors)
        }
        
        // 3) Karakter sınıfları
        let hasUpper = password.contains { $0.isUppercase }
        let hasLower = password.contains { $0.isLowercase }
        let hasDigit = password.contains { $0.isNumber }
        let hasSpecial = password.contains { !$0.isLetter && !$0.isNumber }
        
        if policy.requireUpperCase && !hasUpper {
            let message = NSLocalizedString("sign_up.password_validation.requires_uppercase", comment: "")
            errors.append(message)
            return .fail(errors)
        }
        if policy.requireLowerCase && !hasLower {
            let message = NSLocalizedString("sign_up.password_validation.requires_lowercase", comment: "")
            errors.append(message)
            return .fail(errors)
        }
        if policy.requireNumber && !hasDigit {
            let message = NSLocalizedString("sign_up.password_validation.requires_number", comment: "")
            errors.append(message)
            return .fail(errors)
        }
        if policy.requireSpecial && !hasSpecial {
            let message = NSLocalizedString("sign_up.password_validation.requires_special", comment: "")
            errors.append(message)
            return .fail(errors)
        }
        
        if !errors.isEmpty {
            return .fail(errors)
        }
        
        return .ok()
    }
}
