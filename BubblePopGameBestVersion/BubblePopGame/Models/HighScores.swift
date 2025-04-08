//
//  File.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 8/4/2025.
//

import Foundation

struct HighScores: Codable, Identifiable{
    var id = UUID()
    var playerName: String
    var score: Int
}
