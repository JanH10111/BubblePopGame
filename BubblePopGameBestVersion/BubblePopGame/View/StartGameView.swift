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
                            startBubbleGeneration()
                        }
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                                onCountDown()
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
            
            ZStack {
                ForEach(bubbles) { bubble in
                    Bubble(score: $score, position: bubble.position, id: bubble.id, removeBubble: removeBubble)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .ignoresSafeArea()
    }
    
    struct BubbleData: Identifiable {
        let id: UUID
        let position: CGPoint
    }
    
    func startBubbleGeneration() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.1...1), repeats: true) { timer in
            if bubbles.count < 15 {
                addBubble()
            }
        }
    }
    
    func addBubble() {
        let diameter = UIScreen.main.bounds.width / 6
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height * 0.6  // Limit placement area
        
        let randomPosition = CGPoint(
            x: CGFloat.random(in: diameter...(screenWidth - diameter)),
            y: CGFloat.random(in: diameter...(screenHeight - diameter))
        )
        
        // Ensure no overlapping
        if !bubbles.contains(where: { bubble in
            let distance = hypot(bubble.position.x - randomPosition.x, bubble.position.y - randomPosition.y)
            return distance < diameter * 1.1 // Adding a small margin for safety
        }) {
            let newBubble = BubbleData(id: UUID(), position: randomPosition)
            
            DispatchQueue.main.async {
                // Re-check before appending to avoid race condition
                if !bubbles.contains(where: { bubble in
                    let distance = hypot(bubble.position.x - newBubble.position.x, bubble.position.y - newBubble.position.y)
                    return distance < diameter * 1.1
                }) {
                    bubbles.append(newBubble)
                    removeBubbleAfterDelay(newBubble.id)
                }
            }
        }
    }

    func removeBubbleAfterDelay(_ id: UUID) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...5)) {
            bubbles.removeAll { $0.id == id }
        }
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

