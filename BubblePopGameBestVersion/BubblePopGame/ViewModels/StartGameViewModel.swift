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
    private var bubbleSpawnInterval: Double = 0.3
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private var numberOfLanes: Int
    private var laneCooldowns: [Int: Bool] = [:]
    
    
    
    init(timerValue: Double, numberOfBubbles: Double, playerName: String) {
            self.timerValue = timerValue
            self.numberOfBubbles = numberOfBubbles
            self.countdownInSeconds = Int(timerValue)
            self.playerName = playerName
        self.numberOfLanes = Int(screenWidth / (UIScreen.main.bounds.width / 6))
        for i in 0..<numberOfLanes {
            laneCooldowns[i] = true
        }
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
    func spawnBubble() {
        guard let lane = getAvailableLane() else {
            // No lane available right now
            return
        }

        let bubbleValue: Int
        let randomColor: Color
        let possibility = Int.random(in: 0..<100)
        
        switch possibility {
        case 0...39: bubbleValue = 1; randomColor = .red
        case 40...69: bubbleValue = 2; randomColor = .pink
        case 70...84: bubbleValue = 5; randomColor = .green
        case 85...94: bubbleValue = 8; randomColor = .blue
        case 95...99: bubbleValue = 10; randomColor = .black
        default: bubbleValue = 0; randomColor = .yellow
        }

        let speed = 60.0 * (1 + exp(1.5 * (1 - Double(countdownInSeconds) / timerValue)))
        
        // Position the bubble based on lane
        let laneWidth = screenWidth / CGFloat(numberOfLanes)
        let xPos = CGFloat(lane) * laneWidth + laneWidth / 2
        let startPos = CGPoint(x: xPos, y: screenHeight + 50)

        var bubble = BubbleData(position: startPos, speed: speed, color: randomColor, value: bubbleValue)
        
        // Lock the lane temporarily based on the bubble’s travel time
        laneCooldowns[lane] = false
        let unlockTime = (screenHeight / speed)/8
        
        DispatchQueue.main.asyncAfter(deadline: .now() + unlockTime) {
            self.laneCooldowns[lane] = true
        }

        bubbles.append(bubble)

        withAnimation(.linear(duration: screenHeight/speed)) {
            moveBubbleToTop(&bubble)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + screenHeight/speed) {
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
    
    
    func getAvailableLane() -> Int? {
        let availableLanes = laneCooldowns.filter { $0.value }.map { $0.key }
        return availableLanes.randomElement()
    }


      
        
        }


    

