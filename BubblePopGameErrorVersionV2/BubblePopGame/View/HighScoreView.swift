//
//  HighScoreView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct HighScoreView: View {
    
    @StateObject var highScoreViewModel = HighScoreViewModel()
    var score : Int
    var playerName : String
    
    init(score: Int, playerName: String) {
        _highScoreViewModel = StateObject(wrappedValue: StartGameViewModel(score: score, playerName : playerName))
    }
    
   
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Score Board")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .onAppear{highScoreViewModel.addScore(playerName: playerName, score: score)}
                
                //Score Board
                VStack(spacing: 15) {
                    HStack {
                        Text("Name")
                            .font(.headline)
                        Spacer()
                        Text("Score")
                            .font(.headline)
                    }
                    .padding(.horizontal, 50)
                    
                    Divider()
                    List(highScores){
                        Highscores in Text("\(highScores.playerName): \(highScores.score)"
                    }
                    List{
                        ForEach(highScoreViewModel.highScores, id: \.name) { entry in
                            HStack {
                                Text(entry.name)
                                Spacer()
                                Text("\(entry.score)")
                            }
                        }
                          //  .padding(.horizontal, 50)
                        }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                .onAppear{
                    loadPlayerScore()
                    savePlayerScore()
                }
                
                Spacer()
                
                // Homebutton
                
                NavigationLink(destination: ContentView(),
                               label: {
                    Text("Home")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.bottom, 60)
                })}
            
            .padding()
        }
    }

#Preview {
    HighScoreView(score:105, playerName: "Max")
}
