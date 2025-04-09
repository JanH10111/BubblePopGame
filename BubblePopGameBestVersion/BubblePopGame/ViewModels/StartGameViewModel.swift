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
        let maxBubbles = Int(numberOfBubbles)
        
        Timer.scheduledTimer(withTimeInterval: bubbleSpawnInterval, repeats: true) { timer in
            if self.bubbles.count < maxBubbles {
                self.spawnBubble()
            }
//            else{
//                timer.invalidate()
//            }
        }
    }
    
    //Function to spawn a new bubble at a random position with random parameters
    func spawnBubble(){
        var initialPosition: CGPoint = .zero
        let randomColor: Color
        let bubbleValue: Int
        let possibility = Int.random(in: 0..<100)
        switch possibility {
        case 0...39:
            bubbleValue = 1
            randomColor = .red
        case 40...69:
            bubbleValue = 2
            randomColor = .pink
        case 70...84:
            bubbleValue = 5
            randomColor = .green
        case 85...94:
            bubbleValue = 8
            randomColor = .blue
        case 95...99:
            bubbleValue = 10
            randomColor = .black
        default:
            bubbleValue = 0
            randomColor = .yellow
        }
        let speed = 7.0
        var positionIsValid = false
        let minSpacing: CGFloat = bubbleRadius
        
        var attempts = 0
        let maxAttempts = 20
        
        while !positionIsValid && attempts < maxAttempts {
                let potentialX = CGFloat.random(in: 50...(screenWidth - 50))
                let potentialPosition = CGPoint(x: potentialX, y: screenHeight + 50)

                positionIsValid = !bubbles.contains {
                    let isNearBottom = $0.position.y > screenHeight - 100
                    let isTooClose = abs($0.position.x - potentialX) < minSpacing
                    return isNearBottom && isTooClose
                }


                if positionIsValid {
                    initialPosition = potentialPosition
                }
            attempts += 1
            }
        
        var bubble = BubbleData(position: initialPosition, speed: speed, color: randomColor, value: bubbleValue)
        
        
        bubbles.append(bubble)
        
        withAnimation(.linear(duration: speed)){
            moveBubbleToTop(&bubble)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
               self.removeBubble(id: bubble.id)
           }
        
    }
    
    //Function to move the ballooon to the top of the screen
    func moveBubbleToTop (_ bubble: inout BubbleData){
        let endPosition = CGPoint(x: bubble.position.x, y: -150)
        bubble.position = endPosition
        
        if let index = bubbles.firstIndex(where: { $0.id == bubble.id}) {
            bubbles[index] = bubble}
        }
    
    func popBubble(_ bubble: BubbleData) {
        guard let index = bubbles.firstIndex(where: { $0.id == bubble.id }) else {return}
        if !bubbles[index].isPopped {
                bubbles[index].isPopped = true

                let currentColor = bubbles[index].color
                let bubbleValue = bubbles[index].value

                // Check for color match (combo)
                if let lastColor = lastPoppedColor, lastColor == currentColor {
                    score += Int(Double(bubbleValue) * 1.5)
                } else {
                    score += bubbleValue
                }
                lastPoppedColor = currentColor
            }
            }
        }
  
    
    

