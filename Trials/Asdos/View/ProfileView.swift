//
//  ProfileView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 03/10/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            ProfileCard(user: viewModel.user)
            HStack {
                Text("Friend Suggestion")
                    .font(.headline)
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.users) { user in
                        FriendCard(user: user) {
                            viewModel.addFriend(for: user)
                        }
                    }
                }
            }
            HStack {
                Text("Workout List")
                    .font(.headline)
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(viewModel.workouts) { workout in
                        WorkoutCard(workout: workout) {
                            viewModel.toggleWorkout(for: workout)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    ProfileView()
}
