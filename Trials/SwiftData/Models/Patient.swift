//
//  Patient.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftData

@Model
class Patient {
    var name: String
    var address: String
    var phoneNumber: String
    var email: String
    var appointments: [Appointment] = []
    
    init(name: String, address: String, phoneNumber: String, email: String) {
        self.name = name
        self.address = address
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
