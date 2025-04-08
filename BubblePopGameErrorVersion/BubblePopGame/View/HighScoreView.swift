//
//  HighScoreView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct HighScoreView: View {
    
    @ObservedObject var highScoreViewModel = HighScoreViewModel()
    var score : Int
    var playerName: String
    
   
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Score Board")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .onAppear{
                        highScoreViewModel.loadHighScores()
                        highScoreViewModel.savePlayerScore(playerName: playerName, score: score)
                    }
                
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
                    
                    List(highScoreViewModel.highScores) { score in
                                    Text("\(score.playerName): \(score.score)")
                                }
                        .padding(.horizontal, 50)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
                
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
                })
            
            .padding()
        }
}
#Preview {
    HighScoreView(score:55, playerName: "Max")
}
