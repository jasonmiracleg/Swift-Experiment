//
//  ProfileView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 03/10/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: MainViewModel
    
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
                Text("Recently Added")
                    .font(.headline)
                Spacer()
            }
            if viewModel.user.friends.isEmpty {
                Spacer()
                Text("No Friends yet.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach($viewModel.user.friends.suffix(3)) { $user in
                            FriendCard(user: $user, isVisible: false)
                        }
                    }
                }
            }
            HStack {
                Text("Recent Workouts")
                    .font(.headline)
                Spacer()
            }
            if viewModel.user.workouts.isEmpty {
                Spacer()
                Text("No Workouts yet")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach($viewModel.user.workouts.suffix(3)) { $workout in
                            WorkoutCard(workout: $workout, isVisible: false)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 32)
    }
}
