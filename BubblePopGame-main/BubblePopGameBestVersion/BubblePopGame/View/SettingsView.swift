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
        VStack {
            HStack{
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(.mint)
                    .font(.system(size: 25))
                Label("Settings", systemImage: "")
                    .foregroundStyle(.mint)
                    .font(.largeTitle.bold())
            }.padding(.top)
            
            Spacer()

            VStack {
                Text("Enter Your Name")
                    .font(.headline)
                TextField("Enter Name", text: $playerName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.mint)
            .padding(.horizontal, 40)

            Spacer()

            VStack {
                Text("Game Time: \(Int(countdownValue)) sec")
                    .font(.headline)
                Slider(value: $countdownValue, in: 0...60, step: 1)
                    .onChange(of: countdownValue) {
                        countdownInput = "\(Int(countdownValue))"
                    }.tint(.gray)
                
            }
            .foregroundStyle(.mint)
            .padding(.horizontal, 40)

            Spacer()
            
            VStack {
                Text("Max Number of Bubbles: \(Int(numberOfBubbles))")
                                        .font(.headline)
                Slider(value: $numberOfBubbles, in: 0...15, step: 1)
                    .tint(.gray)
            }
            .foregroundStyle(.mint)
            .padding(.horizontal, 40)
            
            Spacer()

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
                Button("OK", role: .cancel) {}
            }
            .navigationDestination(isPresented: $navigateToStartGame) {
                StartGameView(
                    timerValue: countdownValue,
                    numberOfBubbles: numberOfBubbles, playerName: playerName)
            }
            .font(.title2.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.9))
            .foregroundStyle(.mint)
            .cornerRadius(20)
            .shadow(radius: 5)
            .padding(.horizontal, 40)
            
            Spacer()

        }
    }
}

#Preview {
    SettingsView()
}
