//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    
    var timerValue : Double
    
    var body: some View {
        Label("Game started!", systemImage: "")
            .foregroundStyle(.purple)
            .font(.title)
        
        
        Text("\(timerValue)")
        
    }
}

#Preview {
    StartGameView(timerValue: 50)
}
