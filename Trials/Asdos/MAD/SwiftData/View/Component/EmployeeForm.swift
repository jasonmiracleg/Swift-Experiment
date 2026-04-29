//
//  EmployeeForm.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 29/04/26.
//

import SwiftUI

struct EmployeeForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let company: Company
    var employeeToEdit: Employee? = nil
    
    @State private var name: String = ""
    @State private var position: String = ""
    
    init(company: Company, employeeToEdit: Employee? = nil) {
        self.company = company
        self.employeeToEdit = employeeToEdit
        
        _name = State(initialValue: employeeToEdit?.name ?? "")
        _position = State(initialValue: employeeToEdit?.position ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Employee Information") {
                    TextField("Name", text: $name)
                    TextField("Role", text: $position)
                }
            }
            .navigationTitle(employeeToEdit == nil ? "New Employee" : "Edit Employee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        saveEmployee()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    
    private func saveEmployee() {
        if let employee = employeeToEdit {
            employee.name = name
            employee.position = position
        } else {
            let newEmployee = Employee(name: name, position: position, company: company)
            modelContext.insert(newEmployee)
        }
    }
}
