//
//  PasswordRule.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//

import Foundation

struct PasswordRule: Hashable {
    let key: String
    let satisfied: Bool
    let localizedMessage: String

    init(key: String, arguments: [CVarArg], satisfied: Bool) {
        self.key = key
        self.satisfied = satisfied
        let format = NSLocalizedString(key, comment: "")
        self.localizedMessage = String.localizedStringWithFormat(
            format,
            arguments
        )
    }

    static func rules(for policy: PasswordPolicy) -> [PasswordRule] {
        var r = [
            PasswordRule(
                key: "password.rule.min_length",
                arguments: [policy.minLength],
                satisfied: false
            ),
            PasswordRule(
                key: "password.rule.max_length",
                arguments: [policy.maxLength],
                satisfied: false
            ),
        ]

        let others = [
            ("password.rule.requires_uppercase", policy.requireUpperCase),
            ("password.rule.requires_lowercase", policy.requireLowerCase),
            ("password.rule.requires_number", policy.requireNumber),
            ("password.rule.requires_special", policy.requireSpecial),

        ].filter { (key, exists) in
            exists
        }
        .map({ (key, exists) in
            return PasswordRule.ruleWithoutArgs(key: key)
        })

        r.append(contentsOf: others)
        return r

    }

    static func ruleWithoutArgs(key: String) -> PasswordRule {
        return PasswordRule(
            key: key,
            arguments: [],
            satisfied: false
        )
    }
}
/**
 password.rule.min_length = "At least %d characters.";
 password.rule.max_length = "At most %d characters.";
 password.rule.requires_uppercase = "Needs an uppercase letter.";
 password.rule.requires_lowercase = "Needs a lowercase letter.";
 password.rule.requires_number = "Needs a number.";
 password.rule.requires_special = "Needs a special character.";

 */
