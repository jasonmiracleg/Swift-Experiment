//
//  Employee.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftData
import Foundation

@Model
class Employee: Identifiable {
    @Attribute(.unique)
    var id: UUID
    
    @Relationship(inverse: \Project.personInCharge)
    var projects: [Project]

    var name: String
    var position: String
    var company: Company?
    
    init(name: String, position: String, company: Company? = nil) {
        self.id = UUID()
        self.name = name
        self.position = position
        self.company = company
        self.projects = []
    }
}
