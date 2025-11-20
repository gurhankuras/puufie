//
//  CustomDialog.swift
//  puutie
//
//  Created by Gurhan on 11/18/25.
//

import SwiftUI

struct CustomDialog<ActionContent: View>: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let dismissible: Bool
    let actions: (() -> ActionContent)?

    init(
        isPresented: Binding<Bool>,
        title: String = "Error",
        dismissible: Bool = true,
        message: String
    ) where ActionContent == EmptyView {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.dismissible = dismissible
        self.actions = nil
    }

    init(
        isPresented: Binding<Bool>,
        title: String = "Error",
        dismissible: Bool = true,
        message: String,
        @ViewBuilder actions: @escaping () -> ActionContent
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.dismissible = dismissible
        self.actions = actions
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.clear
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    header
                    content

                    if let actions {
                        Divider()
                            .background(Color.white.opacity(0.3))
                        HStack {
                            actions()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
                .frame(width: geo.size.width * 0.85)
                .background(Color.darkAccent2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .darkAccent2, radius: 4)
                .overlay(alignment: .topLeading) {
                    if dismissible {
                        closeButton
                    }
                }
            }
        }
    }
    
    private var header: some View {
        HStack(spacing: 5) {
            Spacer()
            Image(systemName: "exclamationmark.circle.fill")
                .font(.title)
                .foregroundStyle(.lightShade2)
                .crispyShadow()

            Text(title)
                .font(.title)
                .fontWeight(.medium)
                .foregroundStyle(.lightShade2)
                .crispyShadow()
            Spacer()
        }
        .padding()
        .background(Rectangle().fill(.accent2))
    }

    private var content: some View {
        Text(message)
            .foregroundColor(.white)
            .font(.title3.weight(.medium))
            .padding(.vertical, 35)
            .padding(.horizontal, 20)
            .multilineTextAlignment(.center)
    }

    private var closeButton: some View {
        Button {
            isPresented = false
        } label: {
            Circle()
                .fill(.black.opacity(0.3))
                .frame(width: 35, height: 35)
                .overlay {
                    Image(systemName: "xmark")
                        .tint(.white)
                        .font(.title3)
                }
                .padding()
        }
    }
}

struct CustomDialog_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            CustomDialog(
                isPresented: .constant(true),
                message: "Something went wrong!"
            )
        }
    }
}

// #Preview(traits: .sizeThatFitsLayout) {}

