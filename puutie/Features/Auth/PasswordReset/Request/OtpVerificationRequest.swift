//
//  OtpVerificationRequest.swift
//  puutie
//
//  Created by Gurhan on 11/19/25.
//


struct OtpVerificationRequest: Encodable {
    let username: String
    let code: String
    let subject: String
}
