//
//  UserListViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/26/25.
//

import Foundation
import Combine
import UIKit

final class UserListViewModel: ObservableObject {
    @Published var users: [UserItem] = SampleUsers.make()
    @Published var query = ""
    @Published var showOnlyActive = true
    @Published var sort: UserSort = .nameAsc
    
    var filtered: [UserItem] {
        var list = users
        if showOnlyActive { list = list.filter { $0.isActive } }
        if !query.isEmpty {
            let q = query.lowercased()
            list = list.filter {
                $0.email.lowercased().contains(q)
                    || $0.username.lowercased().contains(q)
                    || $0.fullName.lowercased().contains(q)
            }
        }
        switch sort {
        case .nameAsc:
            list.sort {
                $0.fullName.localizedCaseInsensitiveCompare($1.fullName)
                    == .orderedAscending
            }
        case .nameDesc:
            list.sort {
                $0.fullName.localizedCaseInsensitiveCompare($1.fullName)
                    == .orderedDescending
            }
        case .emailAsc:
            list.sort {
                $0.email.localizedCaseInsensitiveCompare($1.email)
                    == .orderedAscending
            }
        case .emailDesc:
            list.sort {
                $0.email.localizedCaseInsensitiveCompare($1.email)
                    == .orderedDescending
            }
        }
        return list
    }
    
    
    func resetPassword(_ user: UserItem) {
        // TODO: call backend
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func addInvited(email: String) {
        let new = UserItem(
            id: UUID(),
            email: email,
            firstName: "—",
            lastName: "",
            username: email.split(separator: "@").first.map(String.init)
                ?? email,
            isActive: false
        )
        users.insert(new, at: 0)
    }
    
    func disable(_ user: UserItem) {
        if let idx = users.firstIndex(of: user) {
            users[idx].isActive.toggle()
        }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    func refresh() async {
        try? await Task.sleep(nanoseconds: 700_000_000)
        // TODO: fetch from backend
    }

}
