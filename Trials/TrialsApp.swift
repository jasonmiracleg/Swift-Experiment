//
//  TrialsApp.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 05/06/25.
//

import SwiftUI
import SwiftData

@main
struct TrialsApp: App {
    var body: some Scene {
        WindowGroup {
            RecordingView()
        }
        .modelContainer(for: TranscriptRecord.self)
    }
}
