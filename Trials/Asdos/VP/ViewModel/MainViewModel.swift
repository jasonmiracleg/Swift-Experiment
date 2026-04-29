//
//  MainViewModel.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 13/10/25.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var user: User
    @Published var workouts: [Workout]
    @Published var users: [User]

    init() {
        self.user = User(
            name: "Jamier Tanuwijaya",
            age: 21,
            height: 170,
            weight: 65
        )
        self.workouts = [
            Workout(
                title: "Morning Yoga",
                type: "Flexibility",
                caloriesBurned: 180,
                icon: "figure.cooldown"
            ),
            Workout(
                title: "Cardio Blast",
                type: "Cardio",
                caloriesBurned: 350,
                icon: "figure.run"
            ),
        ]
        self.users = [
            User(name: "Evan Miracle", age: 29, height: 175, weight: 80),
            User(name: "Tanjung Dave", age: 21, height: 170, weight: 70),
            User(name: "Alex Johnson", age: 24, height: 175, weight: 70),
            User(name: "Maria Lee", age: 21, height: 160, weight: 55),
            User(name: "John Doe", age: 26, height: 180, weight: 75),
            User(name: "Sophia Tan", age: 23, height: 165, weight: 58)
        ]
    }

    // MARK: - Workout Methods
    func addWorkout(_ workout: Workout) {
        user.workouts.append(workout)
    }

    func removeWorkout(_ workout: Workout) {
        user.workouts.removeAll { $0.id == workout.id }
    }

    // MARK: - Friend Methods
    func toggleFriendship(for friend: User) {
        guard let index = users.firstIndex(where: { $0.id == friend.id }) else { return }

        // Toggle state in the users array
        users[index].isAdded.toggle()

        if users[index].isAdded {
            // Add friend to the current user’s list
            if !user.friends.contains(where: { $0.id == friend.id }) {
                user.friends.append(users[index])
            }
        } else {
            // Remove friend from the current user’s list
            user.friends.removeAll { $0.id == friend.id }
        }

        // Ensure @Published triggers by reassigning (this forces SwiftUI to refresh)
        objectWillChange.send()
    }
}
