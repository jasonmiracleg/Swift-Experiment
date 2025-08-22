//
//  AddPatientView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftUI

struct AddPatientView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                TextField("Address", text: $address)
                TextField("Email", text: $email)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
            }
            .navigationTitle(Text("New Patient"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if !name.isEmpty, !address.isEmpty, !email.isEmpty, !phoneNumber.isEmpty {
                            let patient = Patient(name: name, address: address, phoneNumber: phoneNumber, email: email)
                            context.insert(patient)
                            try? context.save()
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
            }
        }
    }
}
