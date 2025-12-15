//
//  UserNotificationsViewModel.swift
//  puutie
//
//  Created by Gurhan on 11/29/25.
//


import Combine

@MainActor
class UserNotificationsViewModel: ObservableObject, BaseViewModel {
    @Published var notificationsStatus: AsyncState<PagedResponse<UserNotificationDto>, String> = .idle
    @Published var pagedResponse: PagedResponse<UserNotificationDto>?
    @Published var notifications: [UserNotificationDto] = []

    private var page = 0
    private var pageSize: Int = 20
    
    private let userNotificationProvider: UserNotificationProvider
    
    init(userNotificationProvider: UserNotificationProvider) {
        self.userNotificationProvider = userNotificationProvider
        $notificationsStatus
            .compactMap { status in
                if case .success(let notifications) = status {
                    return notifications
                }
                return nil
            }
            .assign(to: &$pagedResponse)
    }
    
    func fetchNotifications() async -> Void {
        do {
            let items = try await userNotificationProvider.getUserNotifications(page: page, size: pageSize)
            notificationsStatus = .success(items)
            notifications.append(contentsOf: items.content)
        }
        catch  {
            handleError(error, state: &notificationsStatus)
        }
    }
}
