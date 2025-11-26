import SwiftUI

// MARK: - View
struct UsersListView: View {
    @ObservedObject var viewModel: UserListViewModel
    @State private var isInviting = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient.darkGradient.ignoresSafeArea()

            if viewModel.filtered.isEmpty {
                EmptyStateView(
                    query: $viewModel.query,
                    showOnlyActive: $viewModel.showOnlyActive
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
                    dismiss()
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
        .sheet(isPresented: $isInviting) {
            InviteUserSheet { email in
                viewModel.addInvited(email: email)
            }
            .presentationDetents([.height(260)])
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
                        Button(role: .destructive) {
                            viewModel.disable(user)
                        } label: {
                            Label(
                                user.isActive
                                    ? "Disable" : "Enable",
                                systemImage: user.isActive
                                    ? "slash.circle"
                                    : "checkmark.circle"
                            )
                        }
                        Button {
                            viewModel.resetPassword(user)
                        } label: {
                            Label(
                                "Reset Pwd",
                                systemImage: "key.fill"
                            )
                        }
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
        .animation(.easeInOut, value: viewModel.filtered)
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
                    Toggle(isOn: $viewModel.showOnlyActive) {
                        Label(
                            "Sadece aktifler",
                            systemImage: "checkmark.circle"
                        )
                    }
                    .toggleStyle(.switch)
                    Spacer()
                    Text(
                        "\(viewModel.filtered.count) / \(viewModel.users.count)"
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
    UsersListView(viewModel: UserListViewModel())
        .preferredColorScheme(.dark)
}
