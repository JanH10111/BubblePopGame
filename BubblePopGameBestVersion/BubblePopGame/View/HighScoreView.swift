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
                    
                    List(highScoreViewModel.highScores.sorted(by: { $0.score > $1.score }).prefix(5)) { score in
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
                    }
                }
                .padding()
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
            .navigationBarBackButtonHidden(true)
        }
}
#Preview {
    HighScoreView(score:55, playerName: "Max")
}
