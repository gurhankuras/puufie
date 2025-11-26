//
//  SideMenuList.swift
//  puutie
//
//  Created by Gurhan on 11/25/25.
//

import SwiftUI

struct SideMenuList: View {
    var onSelect: (StandardMenuItem) -> Void
    let items: [StandardMenuItem]

    init(
        items: [StandardMenuItem],
        onSelect: @escaping (StandardMenuItem) -> Void
    ) {
        self.onSelect = onSelect
        self.items = items
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.title) { item in
                    Button {
                        onSelect(item)
                        item.action?()
                    } label: {
                        MenuRow(item: item)
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}

struct MenuRow: View {
    let item: StandardMenuItem
    private let iconBox: CGFloat = 28
    private let iconSize: CGFloat = 20

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 20) {
            ZStack {
                Color.clear
                Image(systemName: item.systemImage)
                    .font(.system(size: iconSize, weight: .regular))
                    .imageScale(.medium)
                    .symbolRenderingMode(.monochrome)
                    .tint(.accent2)
            }
            .frame(width: iconBox, height: iconBox, alignment: .center)

            Text(item.title)
                .font(.headline)
                .foregroundStyle(.white)
                .fixedSize(horizontal: true, vertical: true)
            Spacer(minLength: 0)

        }
        .padding(.vertical, 8)
        .padding(.leading, 30)
        .padding(.trailing, 12)
        .contentShape(Rectangle())
    }
}

struct SideMenuList_Previews: PreviewProvider {

    static var previews: some View {

        ZStack {
            Color(.darkAccent2)
                .edgesIgnoringSafeArea(.all)
            SideMenuList(
                items: [
                    StandardMenuItem(
                        systemImage: "gear",
                        title: "Deneme",
                        action: nil
                    ),
                    StandardMenuItem(
                        systemImage: "person.3",
                        title: "Haydi",
                        action: nil
                    ),
                ]
            ) { _ in

            }
        }

    }
}
