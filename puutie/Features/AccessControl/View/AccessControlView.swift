import SwiftUI

// MARK: - Models
struct AccessControlTerm: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tint: Color
    let subtitle: String
    let action: () -> Void
}

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let action: () -> Void
}

struct Activity: Identifiable {
    let id = UUID()
    let text: String
    let icon: String
    let tint: Color
    let time: String
}

// MARK: - View
struct AccessControlView: View {
    @State private var pressedID: UUID?
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    @EnvironmentObject var router: NavigationRouter

    @Environment(\.dismiss) private var dismiss

    private var terms: [AccessControlTerm] {
        [
            .init(
                title: "Users",
                icon: "person.3.fill",
                tint: .blue,
                subtitle: "Yönet ve davet et"
            ) {
                router.push(.users)
            },
            .init(
                title: "Profiles",
                icon: "person.crop.circle.fill",
                tint: .purple,
                subtitle: "Özellik kümeleri"
            ) {
                router.push(.profiles)
            },
            .init(
                title: "Roles",
                icon: "person.2.badge.gearshape.fill",
                tint: .orange,
                subtitle: "Görev ve kapsam"
            ) {
                router.push(.roles)
            },
            .init(
                title: "Permissions",
                icon: "checkmark.shield.fill",
                tint: .green,
                subtitle: "İzin matrisleri"
            ) {
                router.push(.permissions)
            },
        ]
    }

    private var quickActions: [QuickAction] {
        [
            .init(title: "Kullanıcı Davet", icon: "envelope.badge")
            { /* invite */  },
            .init(title: "Rol Oluştur", icon: "plus.rectangle.on.folder")
            { /* create role */  },
            .init(title: "İzin Şablonu", icon: "checklist") { /* template */  },
            .init(title: "Audit Log", icon: "doc.text.magnifyingglass")
            { /* audit */  },
        ]
    }

    private var activities: [Activity] = [
        .init(
            text: "Gurhan, “Admin” rolüne eklendi",
            icon: "person.badge.shield.checkmark.fill",
            tint: .green,
            time: "2 dk"
        ),
        .init(
            text: "Yeni profil: Warehousing",
            icon: "square.stack.3d.up.fill",
            tint: .purple,
            time: "1 s"
        ),
        .init(
            text: "İzin güncelleme: Orders.delete",
            icon: "lock.open.trianglebadge.exclamationmark.fill",
            tint: .orange,
            time: "1 g"
        ),
    ]

    // Örnek metrikler
    @State private var totalUsers = 128
    @State private var totalRoles = 7
    @State private var pendingInvites = 3

    var body: some View {
        ZStack {
            backgroundColor
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Başlık
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Access Control")
                            .font(.largeTitle.weight(.semibold))
                        Text("Kullanıcı, rol ve izinleri tek yerden yönet.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    // Kart grid
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(terms) { item in
                            Button { /* aksiyon bağla */
                                item.action()
                            } label: {
                                AccessControlCard(
                                    item: item,
                                    isPressed: pressedID == item.id
                                )
                            }
                            .buttonStyle(ScaleHapticButtonStyle())
                            .contentShape(
                                RoundedRectangle(
                                    cornerRadius: 22,
                                    style: .continuous
                                )
                            )
                        }
                    }
                    .padding(.horizontal)

                    // Özet Cam Kart
                    SummaryCard(
                        totalUsers: totalUsers,
                        totalRoles: totalRoles,
                        pendingInvites: pendingInvites
                    )
                    .padding(.horizontal)

                    // Quick Actions
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(quickActions) { qa in
                                Button(action: qa.action) {
                                    HStack(spacing: 8) {
                                        Image(systemName: qa.icon)
                                        Text(qa.title)
                                    }
                                    .padding(.horizontal, 14).padding(
                                        .vertical,
                                        10
                                    )
                                    .background(
                                        .ultraThinMaterial,
                                        in: Capsule()
                                    )
                                    .overlay(
                                        Capsule().strokeBorder(
                                            .white.opacity(0.08)
                                        )
                                    )
                                }
                                .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Aktivite Listesi (boş alanı doldurur)
                    Text("Aktivite")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 10) {
                        ForEach(activities) { act in
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(act.tint.opacity(0.2))
                                    .frame(width: 34, height: 34)
                                    .overlay(
                                        Image(systemName: act.icon)
                                            .foregroundStyle(act.tint)
                                            .font(
                                                .system(
                                                    size: 15,
                                                    weight: .semibold
                                                )
                                            )
                                    )
                                Text(act.text)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                Spacer()
                                Text(act.time)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .background(
                                .ultraThinMaterial,
                                in: RoundedRectangle(
                                    cornerRadius: 14,
                                    style: .continuous
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14).stroke(
                                    .white.opacity(0.06)
                                )
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 28)
                }
                .padding(.top, 16)
                // uzun ekranda "boş alan" kalmasın diye alt dolgu
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            // Altta yumuşak vignette
            .overlay(alignment: .bottom) {
                LinearGradient(
                    colors: [.clear, .black.opacity(0.35)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
                .allowsHitTesting(false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }

    private var backgroundColor: some View {
        LinearGradient(
            colors: [
                Color.black, Color(red: 0.07, green: 0.09, blue: 0.15),
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Card


// MARK: - Preview
#Preview {
    AccessControlView()
        .environmentObject(NavigationRouter(paths: [.accessControl]))
        .preferredColorScheme(.dark)
}
