import Foundation
import Combine
import UIKit

@MainActor
final class UserListViewModel: ObservableObject, BaseViewModel {
    @Published var query = ""
    @Published var sort: UserSort = .nameAsc
    @Published var usersStatus: AsyncState<[UserItem], String> = .idle

    // 🔗 Asıl kaynak liste (UI bunun üzerinden çalışacak)
    @Published private(set) var usersList: [UserItem] = []

    private let userService: UserService

    init(userService: UserService) { self.userService = userService }

    // Eski computed `users` yerine sayım gerekiyorsa:
    var usersCount: Int { usersList.count }

    // Filtre her zaman usersList üzerinden
    var filtered: [UserItem] {
        var list = usersList
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
            list.sort { $0.fullName.localizedCaseInsensitiveCompare($1.fullName) == .orderedAscending }
        case .nameDesc:
            list.sort { $0.fullName.localizedCaseInsensitiveCompare($1.fullName) == .orderedDescending }
        case .emailAsc:
            list.sort { $0.email.localizedCaseInsensitiveCompare($1.email) == .orderedAscending }
        case .emailDesc:
            list.sort { $0.email.localizedCaseInsensitiveCompare($1.email) == .orderedDescending }
        }
        return list
    }

    func resetPassword(_ user: UserItem) {
        // TODO: call backend
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    func addInvited(email: String) {
        let new = UserItem(
            id: 9999, // TODO: backend id
            email: email,
            firstName: "—",
            lastName: "",
            username: email.split(separator: "@").first.map(String.init) ?? email
        )
        usersList.insert(new, at: 0) // 🔗 doğrudan listeye ekle
    }

    func getUsers() async {
        usersStatus = .loading
        do {
            let users = try await userService.getUsers()
            let items = users.map { x in
                UserItem(
                    id: x.id,
                    email: x.email ?? "-",
                    firstName: x.firstName ?? "Unknown",
                    lastName: x.lastName ?? "Unknown",
                    username: x.username
                )
            }
            usersList = items                  // 🔗 UI kaynağını güncelle
            usersStatus = .success(items)      // durum ekranları için koru
        } catch {
            handleError(error, state: &usersStatus)
        }
    }

    func refresh() async {
        await getUsers()
    }
}
