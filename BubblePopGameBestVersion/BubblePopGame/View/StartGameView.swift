//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    
    @StateObject private var viewModel: StartGameViewModel
    
    init(timerValue: Double, numberOfBubbles: Double, playerName : String) {
        _viewModel = StateObject(wrappedValue: StartGameViewModel(timerValue: timerValue, numberOfBubbles: numberOfBubbles, playerName: playerName))
    }
    
    var body: some View {
        
        ZStack{
            ZStack {
                ForEach(viewModel.bubbles) { bubble in
                    BubbleView(
                        score: $viewModel.score,
                        lastPoppedColor: $viewModel.lastPoppedColor,
                        bubble: bubble,
                        onTap: {
                            viewModel.popBubble(bubble)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            VStack {
                HStack {
                    VStack {
                        Text("Time Left:")
                            .font(.headline)
                            .foregroundStyle(.mint)
                        Text("\(viewModel.countdownInSeconds)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.mint)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Score:")
                            .font(.headline)
                            .foregroundStyle(.mint)
                        Text(String(viewModel.score))
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.mint)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("Highscore:")
                            .font(.headline)
                            .foregroundStyle(.mint)
                        Text(String(viewModel.highestScore))
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.mint)
                    }
                }
                .padding([.leading, .trailing],30)
                .padding(.top, 65)
                Spacer()
            }
            
        }
        .ignoresSafeArea()
        .onAppear{ viewModel.startTimer()
            viewModel.startGenerateBubbles()
            viewModel.loadHighestScore()
        }
        .navigationDestination(isPresented: $viewModel.navigateToHighScore) {
            HighScoreView(score: viewModel.score, playerName: viewModel.playerName)
        }
    }
    
    // View for the bubbles
    struct BubbleView: View {
        @State private var scale: CGFloat = 1.0
        @Binding var score: Int
        @Binding var lastPoppedColor: Color?
        
        let bubble: BubbleData
        let onTap: () -> Void
        
        private var diameter: CGFloat {
            UIScreen.main.bounds.width / 6
        }
        
        var body: some View {
            Circle()
                .fill(bubble.color)
                .frame(width: 60, height: 60)
                .position(bubble.position)
                .scaleEffect(scale)
                .opacity(bubble.isPopped ? 0 : 1)
                .animation(.easeIn(duration: 0.2), value: scale)
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) {
                        scale = 0.1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        onTap()
                    }
                }
        }
    }
    
}
#Preview {
    StartGameView(timerValue: 40, numberOfBubbles: 15, playerName: "Max")
}

