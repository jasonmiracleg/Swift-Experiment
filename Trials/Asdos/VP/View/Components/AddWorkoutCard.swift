//
//  AddWorkoutCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 12/10/25.
//

import SwiftUI

struct AddWorkoutCard: View {
    @ObservedObject var viewModel: MainViewModel
    var onDismiss: () -> Void

    @State private var title = ""
    @State private var type = ""
    @State private var caloriesBurned = ""
    @State private var icon = "flame"

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Add Workout")
                    .font(.headline)
                Spacer()
            }
            ScrollView {
                VStack(spacing: 24) {
                    // Text Fields
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Workout Title")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("e.g. Morning Run", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Type")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("e.g. Cardio, Strength", text: $type)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Calories Burned")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextField("e.g. 200", text: $caloriesBurned)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }

                    // Icon Picker (horizontal scroll)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Choose Icon")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(
                                    [
                                        "flame.fill", "heart.fill", "bolt.fill",
                                        "figure.walk",
                                        "figure.strengthtraining.traditional",
                                        "basketball.fill",
                                    ],
                                    id: \.self
                                ) { item in
                                    Button(action: { icon = item }) {
                                        Image(systemName: item)
                                            .font(.system(size: 28))
                                            .frame(width: 64, height: 64)
                                            .background(
                                                icon == item
                                                    ? Color.blue.opacity(0.2)
                                                    : Color(.systemGray6)
                                            )
                                            .foregroundColor(
                                                icon == item ? .blue : .gray
                                            )
                                            .clipShape(
                                                RoundedRectangle(
                                                    cornerRadius: 16
                                                )
                                            )
                                            .overlay(
                                                RoundedRectangle(
                                                    cornerRadius: 16
                                                )
                                                .stroke(
                                                    icon == item
                                                        ? Color.blue
                                                        : Color.clear,
                                                    lineWidth: 3
                                                )
                                            )
                                    }
                                    .padding(2)
                                }
                            }
                        }
                    }
                }
                .padding()
            }

            // Save Button (like Android bottom bar button)
            Button(action: addWorkout) {
                Text("Save Workout")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        title.isEmpty || type.isEmpty || caloriesBurned.isEmpty
                            ? Color.gray : Color.blue
                    )
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty || type.isEmpty || caloriesBurned.isEmpty)
            .padding(.horizontal, 16)

            Button(action: onDismiss) {
                Text("Cancel")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Color.red
                    )
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
        }
        .padding()
    }

    private func addWorkout() {
        guard let calories = Int(caloriesBurned) else { return }
        let newWorkout = Workout(
            title: title,
            type: type,
            caloriesBurned: calories,
            icon: icon
        )
        viewModel.addWorkout(newWorkout)
        onDismiss()
    }
}
