//
//  CompanyView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 27/04/26.
//

import SwiftData
import SwiftUI

enum CompanySheet: Identifiable {
    case add
    case edit(Company)
    
    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let company):
            return company.id.uuidString
        }
    }
}

struct CompanyView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \Company.name)
    private var companies: [Company]

    @State private var activeSheet: CompanySheet?

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(companies) { company in
                            NavigationLink {
                                CompanyDetailView(company: company)
                            } label: {
                                CompanyCard(
                                    name: company.name,
                                    employeeCount: company.employees.count,
                                    address: company.address,
                                    activeProjectCount: company.projects.count
                                )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .none) {
                                    activeSheet = .edit(company)
                                } label: {
                                    Label("Update", systemImage: "pencil")
                                }
                                Button(role: .destructive) {
                                    deleteCompany(company)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Companies")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        activeSheet = .add
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    CompanyAddForm()
                    
                case .edit(let company):
                    CompanyAddForm(companyToEdit: company)
                }
            }
        }
    }

    private func deleteCompany(_ company: Company) {
        modelContext.delete(company)
    }
}

#Preview {
    CompanyView()
}
