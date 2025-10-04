//
//  User.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 02/10/25.
//

import Foundation

struct User: Identifiable {
    let id = UUID()
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var workoutsCompleted: Int
    var workouts: [Workout] = []
    var friends: [User] = []
    var isAdded: Bool = false
    
    init(name: String, age: Int, height: Double, weight: Double, workoutsCompleted: Int = 0) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.workoutsCompleted = workoutsCompleted
    }
}
