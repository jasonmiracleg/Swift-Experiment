//
//  ContentView.swift
//  Trials
//
//  Created by Jason Miracle Gunawan on 05/06/25.
//

import SwiftUI
import NaturalLanguage

struct NaturalLanguage: View {
    @State private var inputText: String = ""
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])
    
    private var score: String {
        return sentimentAnalysis(for: inputText)
    }
    
    private func sentimentAnalysis(for text: String) -> String {
        tagger.string = text
        
        let (sentimentScore,_) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        return sentimentScore?.rawValue ?? ""
    }
    
    var body: some View {
        VStack {
            Text("Sentiment Analysis")
            
            TextField("Input Text", text: $inputText)
            
            Text(score)
        }
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    NaturalLanguage()
}
