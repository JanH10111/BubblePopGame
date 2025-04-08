//
//  HighScoreViewModel.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import Foundation
class HighScoreViewModel: ObservableObject {
    @Published var highScores: [HighScores] = []
    @Published var playerName: String
    @Published var score: Int
    
    init(playerName: String, score: Int) {
        self.playerName = playerName
        self.score = score
    }
    
    func loadHighScores(){
        if let data = UserDefaults.standard.data(forKey: "PlayerScores"){
            let decoder = JSONDecoder()
            if let decodedHighScores = try? decoder.decode((HighScores).self, from: data){
                highScores = decodedHighScores
            }
        }
    }
    
    func savePlayerScore(){
        let newHighscore = HighScores(playerName: playerName, score: score)
        HighScores.append(newHighscore)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(highScores){
            UserDefaults.standard.set(encoded, forKey: "PlayerScores")
        }
    }
}
