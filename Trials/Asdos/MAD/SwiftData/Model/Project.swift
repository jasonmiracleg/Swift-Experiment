//
//  Project.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import Foundation
import SwiftData

@Model
class Project: Identifiable {
    @Attribute(.unique)
    var id: UUID
    
    var name: String
    var descriptionProject: String
    var personInCharge: Employee?
    var startDate: Date
    var endDate: Date
    var company: Company?
    
    init(name: String, personInCharge: Employee? = nil, startDate: Date, endDate: Date, company: Company? = nil, description: String = "") {
        self.id = UUID()
        self.name = name
        self.personInCharge = personInCharge
        self.startDate = startDate
        self.endDate = endDate
        self.company = company
        self.descriptionProject = description
    }
}

extension Project {
    var isCompleted: Bool {
        endDate < Date()
    }
    
    var statusText: String {
        if isCompleted {
            return "Completed"
        } else {
            return "Active"
        }
    }
}
