import SwiftUI

struct UsersListView: View {
    @StateObject var viewModel: UserListViewModel
    @State private var isInviting = false
    @EnvironmentObject var router: NavigationRouter

    var body: some View {
        ZStack {
            LinearGradient.darkGradient.ignoresSafeArea()
            if viewModel.filtered.isEmpty {
                EmptyStateView(
                    query: $viewModel.query,
                )
                .padding()
            } else {
                userlist
            }
        }
        .navigationTitle("Users")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    router.pop()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Picker("Sırala", selection: $viewModel.sort) {
                        ForEach(UserSort.allCases) { s in
                            Text(s.title).tag(s)
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }

                Button {
                    isInviting = true
                } label: {
                    Image(systemName: "envelope.badge.fill")
                }
                .accessibilityLabel("Invite user")
            }
        }
        .errorDialog(state: $viewModel.usersStatus)
        .sheet(isPresented: $isInviting) {
            InviteUserSheet { email in
                viewModel.addInvited(email: email)
            }
            .presentationDetents([.height(260)])
        }
        .task {
            await viewModel.getUsers()
        }

    }

    private var userlist: some View {
        List {
            controlsSection

            ForEach(viewModel.filtered) { user in
                UserRow(user: user)
                    .listRowBackground(Color.clear)
                    .swipeActions(
                        edge: .trailing,
                        allowsFullSwipe: true
                    ) {

                        Button {
                            viewModel.resetPassword(user)
                        } label: {
                            VStack(spacing: 0) {
                                Image(systemName: "person.crop.circle.fill")
                                Text("Profil Ata")
                            }

                        }
                        .tint(.purple)
                    }
                    .contextMenu {
                        Button {
                            copyToPasteboard(user.email)
                        } label: {
                            Label(
                                "Copy Email",
                                systemImage: "doc.on.doc"
                            )
                        }
                        Button {
                        } label: {
                            Label(
                                "View Details",
                                systemImage: "info.circle"
                            )
                        }
                    }
            }
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .animation(.easeInOut, value: viewModel.usersList)
        .refreshable {
            await viewModel.refresh()
        }
    }

    // MARK: - Subviews
    private var controlsSection: some View {
        Section {
            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                    TextField(
                        "Ara: ad, email, username",
                        text: $viewModel.query
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    if !viewModel.query.isEmpty {
                        Button {
                            viewModel.query = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(12)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 12, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12).stroke(
                        .white.opacity(0.08)
                    )
                )
                HStack {
                    Spacer()
                    Text(
                        "\(viewModel.filtered.count) / \(viewModel.usersCount)"
                    )
                    .font(.caption).foregroundStyle(.secondary)
                }
            }
            .listRowBackground(Color.clear)
        }
    }

    private func copyToPasteboard(_ s: String) {
        UIPasteboard.general.string = s
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

}

// MARK: - Preview
#Preview {
    UsersListView(viewModel: AppContainer.shared.buildUserListViewModel())
        .preferredColorScheme(.dark)
}
