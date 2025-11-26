//
//  Endpoints+Namespaces.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

// API+Auth.swift
import Foundation

public extension PuutieAPI.Endpoint where NS == PuutieAPI.AuthNS {
    static let login = Self(["login"])
    static let register = Self(["register"])
    static let latestPasswordPolicy = Self(["password-policy","requirements","latest"])
}

// API+User.swift
import Foundation

public extension PuutieAPI.Endpoint where NS == PuutieAPI.UserNS {
    static let root = Self()
    static func byId(_ id: String) -> Self { .segments(id) }
}

// API+ForgotPassword.swift
import Foundation

public extension PuutieAPI.Endpoint where NS == PuutieAPI.ForgotPasswordNS {
    static let request   = Self(["request"])
    static let verifyOtp = Self(["verify-otp"])
    static let reset     = Self(["reset-password"])
}

// API+AppVersion.swift
import Foundation

public extension PuutieAPI.Endpoint where NS == PuutieAPI.AppVersionNS {
    static let version = Self()
}
