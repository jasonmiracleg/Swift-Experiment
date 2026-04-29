//
//  ProjectAddForm.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct ProjectAddForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let company: Company
    var projectToEdit: Project? = nil

    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date().addingTimeInterval(86400)
    @State private var description: String = ""
    @State private var selectedEmployee: Employee?
    
    init(projectToEdit: Project? = nil, company: Company) {
        self.projectToEdit = projectToEdit
        self.company = company
        
        _name = State(initialValue: projectToEdit?.name ?? "")
        _startDate = State(initialValue: projectToEdit?.startDate ?? Date())
        _endDate = State(initialValue: projectToEdit?.endDate ?? Date().addingTimeInterval(86400))
        _description = State(initialValue: projectToEdit?.descriptionProject ?? "")
        _selectedEmployee = State(initialValue: projectToEdit?.personInCharge ?? nil as Employee?)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Project Information") {
                    TextField("Project Name", text: $name)

                    ZStack(alignment: .topLeading) {
                        if description.isEmpty {
                            Text("Enter project description...")
                                .foregroundStyle(.tertiary)
                                .padding(.top, 8)
                                .padding(.leading, 6)
                        }

                        TextEditor(text: $description)
                            .frame(minHeight: 120)
                    }

                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        displayedComponents: .date
                    )

                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        displayedComponents: .date
                    )
                }

                Section("Person In Charge") {
                    Picker("Select Employee", selection: $selectedEmployee) {
                        
                        Text("None")
                            .tag(nil as Employee?)
                        
                        ForEach(company.employees) { employee in
                            Text(employee.name)
                                .tag(Optional(employee))
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle(projectToEdit == nil ? "New Project" : "Edit Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        saveProject()
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }

    private func saveProject() {
        if let project = projectToEdit {
            project.name = name
            project.personInCharge = selectedEmployee
            project.startDate = startDate
            project.endDate = endDate
            project.descriptionProject = description
        } else {
            let newProject = Project(name: name, personInCharge: selectedEmployee, startDate: startDate, endDate: endDate, company: company, description: description)
            modelContext.insert(newProject)
        }
    }
}

#Preview {
    ProjectAddForm(company: Company(name: "PT AMIN", address: "TIDYR"))
}
