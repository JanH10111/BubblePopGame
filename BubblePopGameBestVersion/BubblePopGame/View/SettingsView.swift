//
//  SettingsView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var highScoreViewModel = HighScoreViewModel()
    @State private var countdownInput = ""
    @State private var countdownValue: Double = 60
    @State private var numberOfBubbles: Double = 15
    @State private var playerName: String = ""
    @State private var navigateToStartGame = false
    @State private var showNameAlert = false
    var body: some View {
        VStack{
            Label("Settings", systemImage: "")
                .foregroundStyle(.green)
                .font(.title)
            Spacer()
            Text("Enter Your Name:")
            
            TextField("Enter Name", text: $playerName)
                .padding()
            Spacer()
            Text("Game Time")
            Slider(value: $countdownValue, in: 0...60, step: 1)
                .padding()
                .padding()
                .onChange(of: countdownValue) {
                    countdownInput = "\(Int(countdownValue))"
                }
            Text("\(Int(countdownValue))")
                .padding()
            
            Text("Max Number of Bubbles")
            Slider(value: $numberOfBubbles, in: 0...15, step: 1)
                .padding()
            
            Text("\(Int(numberOfBubbles))")
                .padding()
            
            Button(action: {
                if playerName.isEmpty {
                    showNameAlert = true
                } else {
                    navigateToStartGame = true
                }
            }) {
                Text("Start Game")
                    .font(.title)
            }
            .alert("Please enter a name", isPresented: $showNameAlert) {
                Button("OK", role: .cancel) { }
            }
            .navigationDestination(isPresented: $navigateToStartGame) {
                StartGameView(timerValue: countdownValue, numberOfBubbles: numberOfBubbles, playerName: playerName)
            }
            Spacer()
            
        }
    }
}

#Preview {
    SettingsView()
}
