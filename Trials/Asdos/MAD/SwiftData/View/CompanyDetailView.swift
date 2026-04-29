//
//  CompanyDetailView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct CompanyDetailView: View {
    
    let company: Company
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                NavigationLink {
                    EmployeeView(company: company)
                } label: {
                    CompanyNavigationCard(
                        title: "Employees",
                        systemImage: "person.3.fill",
                        count: company.employees.count,
                        color: .blue
                    )
                }
                .buttonStyle(.plain)
                
                
                NavigationLink {
                    ProjectView(company: company)
                } label: {
                    CompanyNavigationCard(
                        title: "Projects",
                        systemImage: "folder.fill",
                        count: company.projects.count,
                        color: .green
                    )
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding()
            .navigationTitle(company.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CompanyDetailView(company: Company(name: "PT Ciputra Sehat Selalu Amin", address: "Example"))
}
