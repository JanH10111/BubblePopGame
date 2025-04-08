//
//  StartGameViewModel.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import Foundation
import SwiftUI

class StartGameViewModel: ObservableObject {
 
    @Published  var countdownInSeconds: Int
    @Published  var score: Int = 0
    @Published  var bubbles: [BubbleData] = []
    @Published  var gameAreaSize: CGSize = .zero
    @Published  var bubbleRadius = UIScreen.main.bounds.width / 12
    @Published var isCountingDown = false
    @Published var navigateToHighScore = false
    @Published var lastPoppedColor: Color? = nil
    
    private var countdownInput = ""
    private var timerValue : Double
    private var numberOfBubbles: Double
    private var timer: Timer?
    var playerName: String
    private var bubbleSpawnInterval: Double = 0.5
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    
    
    init(timerValue: Double, numberOfBubbles: Double, playerName: String) {
            self.timerValue = timerValue
            self.numberOfBubbles = numberOfBubbles
            self.countdownInSeconds = Int(timerValue)
            self.playerName = playerName
        }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                self.onCountDown()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // onCountDown(): Decrements the countdown timer by one second. If the timer reaches zero, it stops counting down.
    func onCountDown() {
        if countdownInSeconds > 0 {
            countdownInSeconds -= 1
        } else {
            isCountingDown = false
            navigateToHighScore = true
            stopTimer()
        }
    }
    
    func removeBubble(id: UUID) {
        bubbles.removeAll { $0.id == id }
    }
    
    
    func startGenerateBubbles() {
        let screenSize = gameAreaSize
        let maxBubbles = Int(numberOfBubbles)
        let currentCount = bubbles.count
        var newBubbles: [BubbleData] = []
        
        Timer.scheduledTimer(withTimeInterval: bubbleSpawnInterval, repeats: true) { timer in
            if currentCount < numberOfBubbles {
                spawnBubble()
            }
            else{
                timer.invalidate()
            }
        }
    }
    
    //Function to spawn a new bubble at a random position with random parameters
    func spawnBubble(){
        let randomXPosition = CGFloat.random(in: 50...(screenWidth - 50))
        let randomColor =
        
        let randomSpeed = Double.random(in: 5...10)
        let initalPosition CGPoint(x:randomXPosition, y: screenHeight + 50)
        var bubble = Bubble(position: initalPosition, color: randomColor, speed: randomSpeed)
        
        bubbles.append(bubble)
        
        withAnimation(.linear(duration: randomSpeed)){
            moveBubbleToTop(&bubble)
        }
    }
    
    //Function to move the ballooon to the top of the screen
    func moveBubbleToTop (_ bubble: inout Bubble){
        let endPosition = CGPoint(x: bubble.position, y: -150)
        bubble.position = endPosition
        
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id}) {
            bubble[index] = bubble}
        }
    }
  
    
    

