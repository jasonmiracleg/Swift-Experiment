//
//  EmployeeCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 29/04/26.
//

import SwiftUI

struct EmployeeCard: View {
    let employee: Employee
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Avatar
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(initials)
                        .font(.headline)
                        .foregroundStyle(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(employee.name)
                    .font(.headline)
                
                Text(employee.position)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if employee.projects.count > 0 {
                VStack {
                    Text("\(employee.projects.count)")
                        .font(.headline)
                    Text("Projects")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
    }
    
    private var initials: String {
        let parts = employee.name.split(separator: " ")
        return parts.prefix(2).compactMap { $0.first }.map(String.init).joined()
    }
}
