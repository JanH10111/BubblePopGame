//
//  BackgroundOption.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 23/4/2025.
//
// Enum for background options, each case maps to an imageName to easily
// switch between different background images in the StartGameView

import Foundation
import SwiftUI

enum BackgroundOption: String, CaseIterable, Identifiable {
    case sunset = "Sunset"
    case mountains = "Mountains"
    case coast = "Coast"
    
    var id: String { rawValue }
    
    var imageName: String {
        switch self {
        case .sunset:
            return "Sunset"
        case .mountains:
            return "Mountains"
        case .coast:
            return "Coast"
        }
    }
}
