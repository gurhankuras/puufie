//
//  Bundle+shortVersionString.swift
//  puutie
//
//  Created by Gurhan on 11/20/25.
//

import Foundation

extension Bundle {
    var shortVersionString: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
