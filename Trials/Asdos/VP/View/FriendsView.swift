//
//  FriendsView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 12/10/25.
//

import SwiftUI

struct FriendsView: View {
    @StateObject var viewModel: MainViewModel

    @State private var showingProfile = false
    @State private var selectedUser: User? = nil

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Header
                HStack {
                    Text("Friends")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 32)

                // Grid layout
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16),
                        ],
                        spacing: 32
                    ) {
                        ForEach($viewModel.users) { $user in
                            FriendCard(user: $user, onAdd:  {
                                viewModel.toggleFriendship(for: user)
                            }, isVisible: true)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            }

            // Popup profile card
            if showingProfile, let user = selectedUser {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingProfile = false
                        }
                    }

                VStack {
                    ProfileCard(user: user)
                        .frame(maxWidth: 340)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 20)
                        .padding(.vertical, 80)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
}
