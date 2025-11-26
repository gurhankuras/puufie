//
//  Sort.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

enum UserSort: String, CaseIterable, Identifiable {
    case nameAsc, nameDesc, emailAsc, emailDesc
    var id: String { rawValue }
    var title: String {
        switch self {
        case .nameAsc: return "Ad A→Z"
        case .nameDesc: return "Ad Z→A"
        case .emailAsc: return "Email A→Z"
        case .emailDesc: return "Email Z→A"
        }
    }
}
