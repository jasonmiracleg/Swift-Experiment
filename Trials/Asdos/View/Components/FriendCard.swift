//
//  FriendCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 04/10/25.
//

import SwiftUI

struct FriendCard: View {
    let user: User
    var onAdd: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 72, height: 72)
                Image(systemName: "person.fill")
                    .font(.system(size: 34))
                    .opacity(0.8)
            }
            
            // User Info
            VStack(spacing: 4) {
                Text(getShortName(name: user.name))
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(user.age) years old")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button(action: {
                onAdd?()
            }) {
                Text(user.isAdded ? "Added" : "Add Friend")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(user.isAdded ? .gray : .cyan)
                    .clipShape(Capsule())
            }
            .disabled(user.isAdded)
        }
        .padding()
        .frame(width: 150, height: 200)
        .background(Color.cyan.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
    
    func getShortName(name: String) -> String {
        let nameParts = name.split(separator: " ")
        guard let firstName = nameParts.first else { return name }
        
        if let lastName = nameParts.dropFirst().first,
           let initial = lastName.first {
            return "\(firstName) \(String(initial).uppercased())."
        } else {
            return String(firstName)
        }
    }
}


#Preview {
    FriendCard(
        user: User(name: "Jamier Tanuwijaya", age: 21, height: 175, weight: 65)
    )
}
