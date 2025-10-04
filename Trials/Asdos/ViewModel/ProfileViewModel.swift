//
//  ProfileViewModel.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 04/10/25.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User
    var workouts: [Workout]
    var users: [User]
    
    init() {
        self.user = User(
            name: "Jamier Tanuwijaya",
            age: 21,
            height: 170,
            weight: 65
        )
        
        self.workouts = [
            Workout(title: "Morning Yoga", type: "Flexibility", caloriesBurned: 180, icon: "figure.cooldown"),
            Workout(title: "Cardio Blast", type: "Cardio", caloriesBurned: 350, icon: "figure.run"),
            Workout(title: "Strength Training", type: "Strength", caloriesBurned: 400, icon: "figure.strengthtraining.traditional"),
            Workout(title: "Evening Run", type: "Endurance", caloriesBurned: 300, icon: "figure.walk"),
            Workout(title: "HIIT Session", type: "Cardio", caloriesBurned: 450, icon: "flame.fill")
        ]
        
        self.users = [
            User(name: "Evan Miracle", age: 29, height: 175.0, weight: 80.0, workoutsCompleted: 25),
            User(name: "Tanjung Dave", age: 21, height: 170.0, weight: 70.0, workoutsCompleted: 25),
            User(name: "RudiTakbudi", age: 18, height: 165, weight: 63.0, workoutsCompleted: 30),
            User(name: "Widodo Jokowi", age: 40, height: 175.0, weight: 68.0, workoutsCompleted: 25),
            User(name: "Aceeeel", age: 21, height: 164.0, weight: 68.0, workoutsCompleted: 25)
        ]
    }
    
    func toggleWorkout(for workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].isAdded.toggle()
            
            if workouts[index].isAdded {
                user.workouts.append(workout)
            } else {
                user.workouts.removeAll(where: { $0.id == workout.id })
            }
        }
    }

    
    func addFriend(for friend: User) {
        if let index = users.firstIndex(where: { $0.id == friend.id }) {
            if !users[index].isAdded {
                users[index].isAdded = true
                user.friends.append(users[index])
            }
        }
    }
}
