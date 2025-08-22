//
//  PatientDetailView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftUI
import SwiftData

struct PatientDetailView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Package.name) var packages: [Package]
    @State private var showingAddAppointment = false
    
    let patient: Patient
    
    var body: some View {
        Form {
            Section("Patient Info") {
                Text("Name: \(patient.name)")
                Text("Address: \(patient.address)")
                Text("Email: \(patient.email)")
                Text("Phone Number: \(patient.phoneNumber)")
            }
            
            Section("Appointments") {
                if patient.appointments.isEmpty {
                    Text("No Appointments Found")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(patient.appointments) { appointment in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appointment.package.name)
                                .font(.headline)
                            Text("\(appointment.startTime, style: .time) - \(appointment.endTime, style: .time)")
                        }
                    }
                }
            }
        }
        .navigationTitle(patient.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddAppointment = true
                } label: {
                    Label("Add Appointment", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddAppointment) {
            AddAppointmentView(preselectedPatient: patient)
        }
    }
}
