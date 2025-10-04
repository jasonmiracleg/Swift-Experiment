//
//  ProfileCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 02/10/25.
//

import SwiftUI

struct ProfileCard: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 20) {
            // Profile Avatar
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 72, height: 72)
                Image(systemName: "person.fill")
                    .font(.system(size: 34))

                    .opacity(0.8)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("\(user.name), \(user.age)")
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text("\(Int(user.height)) cm / \(Int(user.weight)) kg")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 16) {
                    Label("\(user.workouts.count)", systemImage: "flame.fill")
                        .font(.subheadline)
                        .foregroundStyle(.orange)
                    Label("\(user.friends.count)", systemImage: "person.2.fill")
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(height: 100)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}


#Preview {
    ProfileCard(
        user: User(name: "Jamier Tanuwijaya", age: 21, height: 175, weight: 65)
    )
}
