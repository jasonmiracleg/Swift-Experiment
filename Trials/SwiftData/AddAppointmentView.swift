//
//  AddAppointmentView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftUI
import SwiftData

struct AddAppointmentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    // Fetch from SwiftData
    @Query(sort: \Patient.name) var patients: [Patient]
    @Query(sort: \Package.name) var packages: [Package]
    
    var preselectedPatient: Patient? = nil
    @State private var selectedPackageID: PersistentIdentifier?
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
    @State private var selectedPatient: Patient?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Select Package") {
                    Picker("Package", selection: $selectedPackageID) {
                        ForEach(packages) { pkg in
                            Text("\(pkg.name) – \(pkg.price, specifier: "%.2f")")
                                .tag(pkg.id)
                        }
                    }
                }
                
                Section("Appointment Time") {
                    DatePicker("Start Time", selection: $startTime)
                    DatePicker("End Time", selection: $endTime)
                }
            }
            .navigationTitle("New Appointment")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let patient = selectedPatient,
                           let pkgID = selectedPackageID,
                           let pkg = packages.first(where: { $0.id == pkgID }) {
                            
                            let appt = Appointment(
                                patient: patient,
                                package: pkg,
                                startTime: startTime,
                                endTime: endTime
                            )
                            
                            patient.appointments.append(appt)
                            
                            context.insert(appt)
                            try? context.save()
                            dismiss()
                        }
                    }
                    .disabled(selectedPackageID == nil)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                if selectedPatient == nil {
                    selectedPatient = preselectedPatient
                }
            }
        }
    }
}
