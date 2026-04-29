//
//  Workout.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 02/10/25.
//

import Foundation

struct Workout: Identifiable {
    let id = UUID()
    var title: String
    var type: String
    var caloriesBurned: Int
    var isAdded: Bool
    var icon: String
    
    init(title: String, type: String, caloriesBurned: Int, isAdded: Bool = false, icon: String) {
        self.title = title
        self.type = type
        self.caloriesBurned = caloriesBurned
        self.isAdded = isAdded
        self.icon = icon
    }
}
