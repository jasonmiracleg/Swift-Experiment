//
//  WorkoutView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 12/10/25.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject var viewModel: MainViewModel
    @State private var showingAddWorkout = false

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Workouts")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                if !$viewModel.user.workouts.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 16) {
                            ForEach($viewModel.user.workouts) { $workout in
                                WorkoutCard(workout: $workout, onToggle: {
                                    viewModel.removeWorkout(workout)
                                }, isVisible: true)
                            }
                        }
                    }
                } else {
                    Spacer()
                    Text("No Workouts Found")
                        .font(.headline)
                    Spacer()
                }
            }
            .padding(.horizontal, 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            showingAddWorkout.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: 56, height: 56)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 24)
                }
            }
            
            if showingAddWorkout {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showingAddWorkout = false
                        }
                    }

                VStack {
                    AddWorkoutCard(viewModel: viewModel) {
                        withAnimation {
                            showingAddWorkout = false
                        }
                    }
                    .frame(maxWidth: 360)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)
                    .padding(.vertical, 64)
                }
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
}
