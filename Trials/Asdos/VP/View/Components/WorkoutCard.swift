//
//  WorkoutCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 02/10/25.
//

import SwiftUI

struct WorkoutCard: View {
    @Binding var workout: Workout
    var onToggle: (() -> Void)? = nil
    var isVisible: Bool

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.3))
                    .frame(width: 64, height: 64)
                Image(systemName: workout.icon)
                    .font(.system(size: 28))
                    .opacity(0.8)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(workout.title)
                    .font(.headline)
                    .lineLimit(1)  // prevent overflow
                    .truncationMode(.tail)
                
                Text(String(workout.caloriesBurned) + " Cals")
                    .font(.subheadline)
                
                Text(workout.type)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if isVisible {
                Button(action: {
                    onToggle?()
                }
                ) {
                    Image(
                        systemName: "minus.circle.fill"
                    )
                    .font(.system(size: 28))
                    .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .frame(height: 100)
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

