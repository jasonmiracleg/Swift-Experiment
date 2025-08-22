//
//  PatientListView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftUI
import SwiftData

struct PatientListView: View {
    @Query(sort: \Patient.name) var patients: [Patient]
    @Environment(\.modelContext) private var context
    @State private var showingAddPatientSheet = false
    @Query var packages: [Package]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(patients) { patient in
                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                        HStack {
                            Image(systemName: "person.circle")
                            Text(patient.name)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(patients[index])
                    }
                    try? context.save()
                }
            }
            .navigationTitle("Patients")
            .toolbar {
                Button(action: { showingAddPatientSheet = true}) {
                    Label("Add Patient", systemImage: "person.badge.plus")
                }
            }
            .sheet(isPresented: $showingAddPatientSheet) {
                AddPatientView()
            }
            .onAppear {
                if packages.isEmpty {
                    let dummies = [
                        Package(
                            name: "General Checkup",
                            price: 50,
                            services: [
                                "Blood Pressure", "Basic Lab",
                                "Doctor Consultation",
                            ]
                        ),
                        Package(
                            name: "Full Body Scan",
                            price: 500,
                            services: ["MRI", "CT Scan", "Radiologist Report"]
                        ),
                        Package(
                            name: "Maternity Package",
                            price: 1000,
                            services: [
                                "Prenatal Checkups", "Delivery",
                                "Postnatal Care",
                            ]
                        ),
                    ]
                    
                    for pkg in dummies {
                        context.insert(pkg)
                    }
                    try? context.save()
                }
            }
        }
    }
}
