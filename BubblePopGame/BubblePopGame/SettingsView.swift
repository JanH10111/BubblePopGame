//
//  SettingsView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var highScoreViewModel = HighScoreViewModel()
    @State private var countdownInput = ""
    @State private var countdownValue: Double = 0
    @State private var numberOfBubbles: Double = 0
    var body: some View {
        VStack{
            Label("Settings", systemImage: "")
                .foregroundStyle(.green)
                .font(.title)
            Spacer()
            Text("Enter Your Name:")
            
            TextField("Enter Name", text: $highScoreViewModel.taskDescription)
                .padding()
            Spacer()
            Text("Game Time")
            Slider(value: $countdownValue, in: 0...60, step: 1)
            Text("countdownInput")
                .padding()
                .onChange(of: countdownValue, perform: {value in
                    countdownInput = "\(Int(value))"
                })
            
            Text("Max Number of Bubbles")
            Slider(value: $numberOfBubbles, in: 0...15, step: 1)
                .padding()
            
            Text("\(Int(numberOfBubbles))")
                .padding()
            NavigationLink (
                destination: StartGameView(timerValue: countdownValue),
                label: {
                    Text("Start Game")
                        .font(.title)
                })
            Spacer()
            
        }
    }
}

#Preview {
    SettingsView()
}
