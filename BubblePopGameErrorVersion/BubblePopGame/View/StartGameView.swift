//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    

    @StateObject private var viewModel: StartGameViewModel
        
        // Initialize with the game parameters
        init(timerValue: Double, numberOfBubbles: Double) {
            _viewModel = StateObject(wrappedValue: StartGameViewModel(timerValue: timerValue, numberOfBubbles: numberOfBubbles))
        }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Time Left:")
                        .font(.headline)
                    Text("\(viewModel.countdownInSeconds)")
                        .font(.largeTitle)
                        .bold()
                        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                            viewModel.onCountDown()
                            viewModel.generateBubbles()
                        })
                }
                
                Spacer()
                
                VStack {
                    Text("Score:")
                        .font(.headline)
                    Text(String(viewModel.score))
                        .font(.largeTitle)
                        .bold()
                }
            }
            .padding([.top, .leading, .trailing], 30.0)
            Divider()
            GeometryReader { geo in
                ZStack {
                    ForEach(viewModel.bubbles) { bubble in
                        Bubble(score: $viewModel.score, position: bubble.position, id: bubble.id, removeBubble: viewModel.removeBubble)
                    }
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .onAppear {
                viewModel.gameAreaSize = geo.size
            }
            }
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

