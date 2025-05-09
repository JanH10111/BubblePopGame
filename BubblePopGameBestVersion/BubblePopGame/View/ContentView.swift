//
//  ContentView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//
// Homeview where the player can create a new game or navigate to the highscores

import SwiftUI

struct ContentView: View {

    @State private var imageVisible = false
    @Environment(\.verticalSizeClass) var verticalSizeClass // Tells whether there is enough vertical space to display the heading

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                if verticalSizeClass != .compact {
                    //Image of the game that fades in
                    Image("BubblepopImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .cornerRadius(25)
                        .shadow(radius: 20)
                        .padding(.top, 60)
                        .opacity(imageVisible ? 1 : 0.1)
                        .animation(.easeInOut(duration: 1.5), value: imageVisible)
                        .onAppear { imageVisible = true }
                }
                Spacer()

                Text("Welcome to Bubble Pop!")
                    .font(.title)
                    .fontWeight(.heavy).foregroundColor(.skyblue)

                Spacer()

                // Button create a new game by navigation to the SettingsView
                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("New Game")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundStyle(.skyblue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                )
                .padding(.horizontal, 40)

                //Button to navigate to the HighScoreView
                NavigationLink(
                    destination: HighScoreView(score: 0, playerName: ""),
                    label: {
                        Text("High Scores")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundStyle(.skyblue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                )
                .padding(.horizontal, 40)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
