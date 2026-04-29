//
//  Company.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 28/04/26.
//

import SwiftData
import Foundation

@Model
class Company: Identifiable {
    @Attribute(.unique)
    var id: UUID
    
    @Relationship(deleteRule: .cascade, inverse: \Employee.company)
    var employees: [Employee] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Project.company)
    var projects: [Project] = []
    
    var name: String
    var address: String
    
    init (id: UUID = UUID(), name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}
