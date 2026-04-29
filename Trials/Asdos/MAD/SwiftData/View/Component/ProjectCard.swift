//
//  ProjectCard.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct ProjectCard: View {
    
    let project: Project
    
    private var dateRangeText: String {
        "\(project.startDate.formatted(date: .abbreviated, time: .omitted)) - \(project.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
    
    private var statusColor: Color {
        switch project.statusText {
        case "Completed":
            return .green
        default:
            return .blue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: Top Row
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(project.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(project.statusText)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(statusColor.opacity(0.2))
                        .foregroundStyle(statusColor)
                        .clipShape(Capsule())
                }
                Text(project.descriptionProject)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            
            // MARK: Date Range
            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(dateRangeText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: Bottom Row
            HStack {
                // Person in charge
                if let person = project.personInCharge {
                    Label(person.name, systemImage: "person.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Label("Unassigned", systemImage: "person.crop.circle.badge.exclamationmark")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground).opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    ProjectCard(project: Project(name: "Medicare", personInCharge: Employee(name: "Jamir", position: "Tech Lead"), startDate: Date(), endDate: Date().addingTimeInterval(86400), company: Company(name: "PT Amaan", address: "Boulevard de la République, 75008 Paris, France"), description: "Something about something"))
}
