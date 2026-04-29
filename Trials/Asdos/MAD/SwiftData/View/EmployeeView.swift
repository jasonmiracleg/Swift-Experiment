//
//  EmployeeView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct EmployeeView: View {
    @Environment(\.modelContext) private var modelContext
    
    let company: Company
    
    enum EmployeeSheet: Identifiable {
        case add
        case edit(Employee)
        
        var id: String {
            switch self {
            case .add:
                return "add"
            case .edit(let employee):
                return employee.id.uuidString
            }
        }
    }
    
    @State private var activeSheet: EmployeeSheet?
    
    var body: some View {
        NavigationStack {
            VStack {
                if company.employees.isEmpty {
                    Spacer()
                    Text("No employees yet.")
                        .foregroundStyle(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(company.employees) { employee in
                                EmployeeCard(employee: employee)
                                    .contextMenu {
                                        Button {
                                            activeSheet = .edit(employee)
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        
                                        Button(role: .destructive) {
                                            deleteEmployee(employee)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .navigationTitle("Employees")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    EmployeeForm(company: company)
                case .edit(let employee):
                    EmployeeForm(company: company, employeeToEdit: employee)
                }
            }
        }
    }
    
    private func deleteEmployee(_ employee: Employee) {
        modelContext.delete(employee)
    }
}
