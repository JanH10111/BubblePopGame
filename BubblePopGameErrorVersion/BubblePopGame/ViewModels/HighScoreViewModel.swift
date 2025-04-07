//
//  HighScoreViewModel.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import Foundation
class HighScoreViewModel: ObservableObject {
    @Published var playerName: String = ""
    @Published var highScores: [(name: String, score: Int)] = [
        ("Alice", 120),
        ("Bob", 100),
        ("Charlie", 85),
        ("Diana", 75),
        ("Eve", 60)
    ]
    
    func addScore(name: String, score: Int) {
        highScores.append((name: playerName, score: score))
        highScores.sort { $0.score > $1.score }
    }
}
