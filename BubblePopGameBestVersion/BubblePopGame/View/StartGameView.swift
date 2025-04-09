//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    
    @StateObject private var viewModel: StartGameViewModel
        
        // Initialize with the parameters
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
                                    bubble: bubble
                                )
                            .onTapGesture {
                                viewModel.popBubble(bubble)
                            }
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
                    }
                    .padding([.top, .leading, .trailing],50)
                    Spacer()
                }
                
            }
            .ignoresSafeArea()
            .onAppear{ viewModel.startTimer()
                viewModel.startGenerateBubbles()
            }
            .navigationDestination(isPresented: $viewModel.navigateToHighScore) {
                            HighScoreView(score: viewModel.score, playerName: viewModel.playerName)
                        }
        }
    

    
    // View for the bubbles
    struct BubbleView: View {
        @State private var value: Int = 0
        @State private var scale: CGFloat = 1.0
        @State private var color: Color = .yellow  // Default color
        @State private var isVisible: Bool = true
        @Binding var score: Int
        @Binding var lastPoppedColor: Color?
        
        let bubble: BubbleData
        
        private var diameter: CGFloat {
            UIScreen.main.bounds.width / 6
        }
        
        var body: some View {
            Circle()
                .fill(bubble.color)
                .frame(width: 60, height: 60)
                .position(bubble.position)
                .opacity(bubble.isPopped ? 0 : 1)
        }
    }
    
}
#Preview {
    StartGameView(timerValue: 20, numberOfBubbles: 10, playerName: "Max")
}

