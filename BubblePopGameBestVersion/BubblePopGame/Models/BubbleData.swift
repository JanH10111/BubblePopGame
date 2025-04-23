//
//  StartGameModel.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 7/4/2025.
//
// Model representing a single bubble in the game, including position, speed, color, score value, and pop state.

import Foundation
import SwiftUI

struct BubbleData: Identifiable {
    let id: UUID = UUID()
    var position: CGPoint
    var speed: Double
    var color: Color
    var isPopped: Bool = false
    var value: Int
}
