//
//  UserNotificationsView.swift
//  puutie
//
//  Created by Gurhan on 11/28/25.
//

import SwiftUI

struct UserNotificationsView: View {
    @StateObject var viewModel: UserNotificationsViewModel = AppContainer.shared.buildUserNotificationViewModel()
    @EnvironmentObject var router: NavigationRouter
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.notifications) { notification in
                    InboxNotificationRow(notification: notification)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .navigationTitle("Notifications")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .task {
            await viewModel.fetchNotifications()
        }
    }
}

struct UserNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserNotificationsView()
    }
}
