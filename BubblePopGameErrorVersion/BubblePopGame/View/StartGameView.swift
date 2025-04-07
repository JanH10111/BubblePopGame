//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    
    var timerValue : Double
    var numberOfBubbles: Double
    @State private var countdownInSeconds = 0
    @State private var isCountingDown = false
    @State private var countdownInput = ""
    @State private var score = 0
    @State private var bubbles: [BubbleData] = []
    @State private var gameAreaSize: CGSize = .zero

    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Time Left:")
                        .font(.headline)
                    Text("\(countdownInSeconds)")
                        .font(.largeTitle)
                        .bold()
                        .onAppear {
                            countdownInSeconds = Int(timerValue)
                            isCountingDown = true
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                                onCountDown()
                                generateBubbles()
                        })
                }
                
                Spacer()
                
                VStack {
                    Text("Score:")
                        .font(.headline)
                    Text(String(score))
                        .font(.largeTitle)
                        .bold()
                }
            }
            .padding([.top, .leading, .trailing], 30.0)
            Divider()
            GeometryReader { geo in
                ZStack {
                    ForEach(bubbles) { bubble in
                        Bubble(score: $score, position: bubble.position, id: bubble.id, removeBubble: removeBubble)
                    }
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .onAppear {
                gameAreaSize = geo.size
            }
            }
        }
    }
    
    struct BubbleData: Identifiable {
        let id: UUID
        let position: CGPoint
    }
    
    //
    
    func generateBubbles() {
        let screenSize = gameAreaSize
        let bubbleRadius = UIScreen.main.bounds.width / 12
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
    
    
    func removeBubble(id: UUID) {
        bubbles.removeAll { $0.id == id }
    }
    
    // onCountDown(): Decrements the countdown timer by one second. If the timer reaches zero, it stops counting down.
    func onCountDown() {
        if countdownInSeconds > 0 {
            countdownInSeconds -= 1
        } else {
            isCountingDown = false
        }
    }
    
    struct Bubble: View {
        @State private var value: Int = 0
        @State private var scale: CGFloat = 1.0
        @State private var color: Color = .yellow  // Default color
        @State private var isVisible: Bool = true
        @Binding var score: Int
        
        let position: CGPoint
        let id: UUID
        let removeBubble: (UUID) -> Void
        
        private var diameter: CGFloat {
            UIScreen.main.bounds.width / 6
        }
        
        var body: some View {
            Circle()
                .fill(color)
                .frame(width: diameter)
                .scaleEffect(scale)
                .onAppear {
                    updateColorAndValue()
                }
                .position(position)
                .opacity(isVisible ? 1 : 0)
                .onTapGesture {
                    popBubble()
                }
        }
        
        // Function to set value and color
        private func updateColorAndValue() {
            let possibility = Int.random(in: 0..<100)
            switch possibility {
            case 0...39:
                value = 1
                color = .red
            case 40...69:
                value = 2
                color = .pink
            case 70...84:
                value = 5
                color = .green
            case 85...94:
                value = 8
                color = .blue
            case 95...99:
                value = 10
                color = .black
            default:
                color = .yellow
            }
        }
        
        private func popBubble() {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                scale = 0.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    isVisible = false
                    score += value
                    removeBubble(id)
                }
            }
        }
    }

    
}
#Preview {
    StartGameView(timerValue: 50, numberOfBubbles: 15)
}

