//
//  HighScoreView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//
// View where the score board is displayed.
// The highscores are loaded from a persistent file and sorted. Based on the highscores a list will be dynamically generated showing the five highest scores

import SwiftUI

struct HighScoreView: View {

    @StateObject var highScoreViewModel = HighScoreViewModel()
    var score: Int
    var playerName: String
    @Environment(\.verticalSizeClass) var verticalSizeClass // Tells whether there is enough vertical space to display the heading


    var body: some View {
        VStack(spacing: 20) {
            //Heading of view
            Text("🏅 Highscore Board")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.mint)
                .padding(.top, 30)
                //onAppear the highscores are loaded from the userdefaults and if applicable the new playerscore is added
                .onAppear {
                    withAnimation(.easeIn(duration: 0.4)) {
                        highScoreViewModel.loadHighScores()
                        highScoreViewModel.savePlayerScore(
                            playerName: playerName, score: score)
                    }
                }
            //Spacer if enough space
            if verticalSizeClass != .compact {Spacer()}
            
            //Highscore Board
            // If the device hasn't enough vertical space the table is display as a scrollview
            if verticalSizeClass == .compact {
                                ScrollView {
                                    VStack() {
                                        ForEach(
                                            highScoreViewModel.highScores.sorted(by: { $0.score > $1.score }).prefix(5)
                                        ) { score in
                                            HStack {
                                                Text(score.playerName)
                                                    .font(.body)
                                                    .fontWeight(.medium)

                                                Spacer()

                                                Text("\(score.score)")
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(.horizontal, 100)
                                            .padding(.vertical, 15)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(10)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .frame(height: 200)
            } else {
                VStack(spacing: 15) {
                    HStack {
                        Text("Name")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.mint)
                        Spacer()
                        Text("Score")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.mint)
                    }
                    .padding(.horizontal, 50)
                    
                    Divider()
                        .background(.mint)
                        .padding(.horizontal, 30)
                    List(
                        highScoreViewModel.highScores.sorted(by: {
                            $0.score > $1.score         // ort decending
                        }).prefix(5)                //showing only the highest five scores
                    ) { score in
                        HStack {
                            Text(score.playerName)
                                .font(.body)
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Text("\(score.score)")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 38)
                        
                    }
                    .listStyle(.plain)
                    .frame(height: 300)
                }
            }
            
            //Spacer if enough space
            if verticalSizeClass != .compact {Spacer()}

            // Button to go back to the Homeview
        NavigationLink(
            destination: ContentView(),
            label: {
                Text("Home")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .foregroundStyle(.mint)
                    .cornerRadius(20)
                    .shadow(radius: 5)
            }
        )
        .padding(.horizontal, 40)
        .navigationBarBackButtonHidden(true)
        
        Spacer()
        }
        .padding()
    }
}
#Preview {
    HighScoreView(score: 55, playerName: "Max")
}
