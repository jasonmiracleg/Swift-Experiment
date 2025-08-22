//
//  Package.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 22/08/25.
//

import SwiftData

@Model
class Package {
    var name: String
    var price: Double
    var services: [String]
    
    init(name: String, price: Double, services: [String]) {
        self.name = name
        self.price = price
        self.services = services
    }
}
