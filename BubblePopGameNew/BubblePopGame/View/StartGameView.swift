//
//  StartGameView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct StartGameView: View {
    
    var timerValue : Double
    @State private var countdownInSeconds = 0
    @State private var isCountingDown = false
    @State private var countdownInput = ""
    
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
                        })
                }
                
                Spacer()
                
                VStack {
                    Text("Score:")
                        .font(.headline)
                    Text("0")
                        .font(.largeTitle)
                        .bold()
                }
            }
            .padding([.top, .leading, .trailing], 30.0)
            Divider()
            
            VStack {
                Text("Game Area")
                    .font(.title)
                    .padding()
                
                // Add your game-related UI elements here
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .ignoresSafeArea()
    }
    
    
    // onCountDown(): Decrements the countdown timer by one second. If the timer reaches zero, it stops counting down.
    func onCountDown() {
        if countdownInSeconds > 0 {
            countdownInSeconds -= 1
        } else {
            isCountingDown = false
        }
    }
}
#Preview {
    StartGameView(timerValue: 50)
}

