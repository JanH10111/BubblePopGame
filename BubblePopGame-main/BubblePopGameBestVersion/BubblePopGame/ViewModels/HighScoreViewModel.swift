//
//  HighScoreViewModel.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import Foundation
class HighScoreViewModel: ObservableObject {
    @Published var highScores: [HighScores] = []
    
    // Loads the Highscores from the UserDefaults
    func loadHighScores(){
        if let data = UserDefaults.standard.data(forKey: "HighScores"){
            let decoder = JSONDecoder()
            if let decodedHighScores = try? decoder.decode([HighScores].self, from: data){
                highScores = decodedHighScores
            }
        }
    }
    
    // Addes the new Highscore and saves the Highscores from the UserDefaults
    func savePlayerScore(playerName: String, score: Int){
        if(playerName != ""){
            let newHighscore = HighScores(playerName: playerName, score: score)
            highScores.append(newHighscore)
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(highScores){
                UserDefaults.standard.set(encoded, forKey: "HighScores")
            }
        }
    }
}
