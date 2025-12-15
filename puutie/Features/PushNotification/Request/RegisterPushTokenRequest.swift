//
//  RegisterPushTokenRequest.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//


struct RegisterPushTokenRequest: Encodable {
    let token: String
    let platform: String
    let osVersion: String
    let appVersion: String
}
