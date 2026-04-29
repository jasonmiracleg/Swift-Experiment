//
//  ProjectView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

enum ProjectSheet: Identifiable {
    case add
    case edit(Project)

    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let project):
            return project.id.uuidString
        }
    }
}

struct ProjectView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var activeSheet: ProjectSheet?

    let company: Company

    var body: some View {
        NavigationStack {
            VStack {
                if company.projects.isEmpty {
                    Spacer()
                    Text("No projects added yet.")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(sortedProjects) { project in
                                ProjectCard(project: project)
                                    .contextMenu {
                                        Button(role: .none) {
                                            activeSheet = .edit(project)
                                        } label: {
                                            Label(
                                                "Update",
                                                systemImage: "pencil"
                                            )
                                        }
                                        Button(role: .destructive) {
                                            deleteProject(project)
                                        } label: {
                                            Label(
                                                "Delete",
                                                systemImage: "trash"
                                            )
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .navigationTitle("Projects")
            .navigationBarTitleDisplayMode(.large)
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
                    ProjectAddForm(company: company)

                case .edit(let project):
                    ProjectAddForm(projectToEdit: project, company: company)
                }
            }
        }
    }

    func deleteProject(_ project: Project) {
        modelContext.delete(project)
    }
    
    private var sortedProjects: [Project] {
        company.projects.sorted { lhs, rhs in
            lhs.endDate > rhs.endDate
        }
    }
}

#Preview {
    ProjectView(
        company: Company(
            name: "PT. Ciputra Sehat Selalu Amin",
            address: "ngantuk"
        )
    )
}
