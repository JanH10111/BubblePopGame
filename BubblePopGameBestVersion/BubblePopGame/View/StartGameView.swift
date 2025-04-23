//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//
// View where the game is actually played.

import SwiftUI

struct StartGameView: View {

    // ViewModel to handle gamelogic and state
    @StateObject private var viewModel: StartGameViewModel

    // Custom initializer to pass required game settings and name of player
    init(
        timerValue: Double, numberOfBubbles: Double, playerName: String,
        background: BackgroundOption
    ) {
        _viewModel = StateObject(
            wrappedValue: StartGameViewModel(
                timerValue: timerValue, numberOfBubbles: numberOfBubbles,
                playerName: playerName, background: background))
    }

    var body: some View {
        ZStack {
            // Layer to show all active views of bubbles
            ZStack {
                ForEach(viewModel.bubbles) { bubble in
                    BubbleView(
                        score: $viewModel.score,
                        lastPoppedColor: $viewModel.lastPoppedColor,
                        bubble: bubble,
                        onTap: {
                            viewModel.popBubble(bubble)  // Handle the removal and addition of the                              value to the score after tapping
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Gamebackground from selected option
            .background(
                Image(viewModel.background.imageName)
                    .resizable()
                    .scaledToFill()
                    .opacity(0.7)
            )
            .cornerRadius(10)
            
            // Displaying the time left, current score and current highscore at the top
            VStack {
                HStack {
                    // Display of countdowntimer
                    VStack {
                        Text("Time Left:")
                            .font(.headline)
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                        
                        Text("\(viewModel.countdownInSeconds)")
                            .font(.largeTitle)
                            .bold()
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                    }

                    Spacer()

                    // Display of current score
                    VStack {
                        Text("Score:")
                            .font(.headline)
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                        Text(String(viewModel.score))
                            .font(.largeTitle)
                            .bold()
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                    }

                    Spacer()

                    //Display of highscore
                    VStack {
                        Text("Highscore:")
                            .font(.headline)
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                        Text(String(viewModel.highestScore))
                            .font(.largeTitle)
                            .bold()
                            .padding(3)
                            .background(Color.black.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(7)
                    }
                }
                .padding([.leading, .trailing], 30)
                .padding(.top, 65)
                
                Spacer()
            }

        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        //onAppear begin countdown, start bubble generation and load highscore from userdefaults
        .onAppear {
            viewModel.startTimer()
            viewModel.startGenerateBubbles()
            viewModel.loadHighestScore()
        }
        .navigationDestination(isPresented: $viewModel.navigateToHighScore) {
            HighScoreView(
                score: viewModel.score, playerName: viewModel.playerName)
        }
        // Stop timer when leaving view
        .onDisappear {
            viewModel.stopTimer()
        }
    }

    // Subview for the bubbles
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
                // When tapped shrink bubble and trigger pop behavior
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
    StartGameView(
        timerValue: 40, numberOfBubbles: 15, playerName: "Max",
        background: .coast)
}
