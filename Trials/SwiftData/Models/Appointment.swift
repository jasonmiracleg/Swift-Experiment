//
//  Appointment.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import Foundation
import SwiftData

@Model
class Appointment {
    var patient: Patient
    var package: Package
    var startTime: Date
    var endTime: Date
    
    init(patient: Patient, package: Package, startTime: Date, endTime: Date) {
        self.patient = patient
        self.package = package
        self.startTime = startTime
        self.endTime = endTime
    }
}
