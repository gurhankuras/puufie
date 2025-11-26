//
//  TokenStore.swift
//  puutie
//
//  Created by Gurhan on 11/24/25.
//
import Foundation


public protocol TokenPersisting: AnyObject {
    func load() -> String?
    func save(_ token: String?) -> Bool
    func delete() -> Bool
}
