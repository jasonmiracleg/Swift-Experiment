//
//  RecordingView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 24/10/25.
//

import SwiftUI
import SwiftData

struct RecordingView: View {
    @StateObject var manager = SpeechManager()
    @State private var showingPermissionAlert = false
    @Environment(\.modelContext) private var context
    @Query(sort: \TranscriptRecord.date, order: .reverse) private var history: [TranscriptRecord]
    
    var body: some View {
            NavigationView {
                VStack(spacing: 16) {
                    // MARK: - Live Transcript
                    VStack(alignment: .leading) {
                        Text("Transcript")
                            .font(.headline)
                        ScrollView {
                            Text(manager.transcript.isEmpty ? "(No transcript yet)" : manager.transcript)
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 240)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    }
                    
                    // MARK: - History Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("History")
                            .font(.headline)
                        if history.isEmpty {
                            Text("(No history yet)")
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)
                        } else {
                            ScrollView {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(history) { record in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(record.text)
                                                .font(.body)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.1))
                                        )
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .frame(height: 180)
                        }
                    }

                    Spacer()

                    // MARK: - Record Button
                    Button(action: toggleRecording) {
                        HStack {
                            Image(systemName: manager.isRecording ? "stop.fill" : "mic.fill")
                            Text(manager.isRecording ? "Stop" : "Record")
                                .bold()
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(manager.isRecording ? Color.red : Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .navigationTitle("Live Transcription")
            }
        }
    
    func toggleRecording() {
        if manager.isRecording {
            manager.stopRecording()
            let trimmed = manager.transcript.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            let record = TranscriptRecord(text: trimmed)
            context.insert(record)
            try? context.save()
        } else {
            manager.requestPermissions { granted in
                DispatchQueue.main.async {
                    if granted {
                        do {
                            try manager.startRecording()
                        } catch {
                            print("Start recording error:", error.localizedDescription)
                        }
                    } else {
                        showingPermissionAlert = true
                    }
                }
            }
        }
    }
}
