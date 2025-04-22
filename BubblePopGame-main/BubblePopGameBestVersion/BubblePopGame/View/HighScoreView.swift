//
//  HighScoreView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct HighScoreView: View {

    @StateObject var highScoreViewModel = HighScoreViewModel()
    var score: Int
    var playerName: String

    var body: some View {
        VStack(spacing: 20) {
            Text("🏅 Score Board")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundStyle(.mint)
                .padding(.top, 30)
                .onAppear {
                    highScoreViewModel.loadHighScores()
                    highScoreViewModel.savePlayerScore(
                        playerName: playerName, score: score)
                }
            Spacer()
            //Score Board
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
                        $0.score > $1.score
                    }).prefix(5)
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

            Spacer()

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
