//
//  CompanyAddForm.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftUI

struct CompanyAddForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var companyToEdit: Company? = nil
    @State private var name: String = ""
    @State private var address: String = ""
    
    init(companyToEdit: Company? = nil) {
        self.companyToEdit = companyToEdit
        
        _name = State(initialValue: companyToEdit?.name ?? "")
        _address = State(initialValue: companyToEdit?.address ?? "")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Company Name", text: $name)
                TextField("Company Address", text: $address)
            }
            .navigationTitle(companyToEdit == nil ? "New Company" : "Edit Company")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button (action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button (action: {
                        saveCompany()
                        dismiss()
                    }) {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
    
    private func saveCompany() {
        if let company = companyToEdit {
            company.name = name
            company.address = address
        } else {
            let newCompany = Company(name: name, address: address)
            modelContext.insert(newCompany)
        }
    }
}

#Preview {
    CompanyAddForm()
}
