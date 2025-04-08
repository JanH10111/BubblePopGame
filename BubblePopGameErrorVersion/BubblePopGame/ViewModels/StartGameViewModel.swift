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
    
    private var countdownInput = ""
    private var timerValue : Double
    private var numberOfBubbles: Double
    private var timer: Timer?
    var playerName: String
    
    
    
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
                self.generateBubbles()
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
    
    
    func generateBubbles() {
        let screenSize = gameAreaSize
        let maxBubbles = Int(numberOfBubbles)
        
        // Decide how many bubbles we want on screen this second
        let desiredBubbleCount = Int.random(in: 1...maxBubbles)
        
        // Randomly remove a few bubbles (e.g., up to half)
        let bubblesToRemove = Int.random(in: 0...(bubbles.count/2))
        for _ in 0..<bubblesToRemove {
            if let randomBubble = bubbles.randomElement() {
                removeBubble(id: randomBubble.id)
            }
        }
        
        // Calculate how many new bubbles we need
        let currentCount = bubbles.count
        let bubblesNeeded = max(0, desiredBubbleCount - currentCount)
        
        var newBubbles: [BubbleData] = []
        
 
            for _ in 0..<bubblesNeeded {
                var newPosition: CGPoint?

                while true {
                    let x = CGFloat.random(in: bubbleRadius...(screenSize.width - bubbleRadius))
                    let y = CGFloat.random(in: bubbleRadius...(screenSize.height - bubbleRadius))
                    let candidate = CGPoint(x: x, y: y)

                    let hasOverlap = (bubbles + newBubbles).contains { existing in
                        let dx = existing.position.x - candidate.x
                        let dy = existing.position.y - candidate.y
                        let distance = sqrt(dx * dx + dy * dy)
                        return distance < bubbleRadius * 2
                    }

                    if !hasOverlap {
                        newPosition = candidate
                        break
                    }
                }

                if let position = newPosition {
                    newBubbles.append(BubbleData(id: UUID(), position: position))
                }
            }
        
        bubbles.append(contentsOf: newBubbles)
    }
    
    
  
    
    
}
