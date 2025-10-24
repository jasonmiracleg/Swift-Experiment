//
//  TranscriptRecord.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 24/10/25.
//

import SwiftData
import Foundation

@Model
final class TranscriptRecord {
    var id: UUID
    var text: String
    var date: Date
    
    init(text: String, date: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.date = date
    }
}
