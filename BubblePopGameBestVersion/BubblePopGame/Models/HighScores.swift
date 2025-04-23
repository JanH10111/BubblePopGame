//
//  File.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 8/4/2025.
//
// Model representing a highscore in the game, including name of player and the achieved highscore

import Foundation

struct HighScores: Codable, Identifiable{
    var id = UUID()
    var playerName: String
    var score: Int
}
