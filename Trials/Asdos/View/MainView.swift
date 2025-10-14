//
//  MainView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 12/10/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        TabView {
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }

            WorkoutView(viewModel: viewModel)
                .tabItem {
                    Label("Workouts", systemImage: "flame.fill")
                }

            FriendsView(viewModel: viewModel)
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
