//
//  Untitled.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 10/06/25.
//

import MusicKit
import SwiftUI
import AVFoundation
import MediaPlayer

@MainActor
class MusicSearchViewModel: ObservableObject {
    @Published var searchResults: MusicItemCollection<Song> = []
    
    func search(for term: String) async {
        do {
            var searchRequest = MusicCatalogSearchRequest(term: term, types: [Song.self])
            searchRequest.limit = 20
            let response = try await searchRequest.response()
            searchResults = response.songs
        } catch {
            print("Search failed: \(error)")
        }
    }
}

struct FavoriteMusic: View {
    @StateObject private var viewModel = MusicSearchViewModel()
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Songs", text: $searchTerm, onCommit: {
                    Task {
                        await viewModel.search(for: searchTerm)
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                List(viewModel.searchResults, id: \.id) { song in
                    Button(action: {
                        play(song: song)
                    }) {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.headline)
                            Text(song.artistName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Apple Music Search")
        }
    }
    
    func play(song: Song) {
        let player = ApplicationMusicPlayer.shared
        Task {
            do {
                if song.playParameters != nil {
                    player.queue = [song]  // This is still the correct API for iOS 16+
                    try await player.play()
                } else {
                    print("This song is not playable.")
                }
            } catch {
                print("Playback failed: \(error)")
            }
        }
    }
    
    func requestMusicAuthorization() async {
        let status = await MusicAuthorization.request()
        print("Music auth status: \(status)")
    }
}

