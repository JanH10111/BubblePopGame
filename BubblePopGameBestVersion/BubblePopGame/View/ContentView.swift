//
//  ContentView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var imageVisible = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Image("BubblepopImage")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .cornerRadius(25)
                    .shadow(radius: 20)
                    .padding(.top, 60)
                    .opacity(imageVisible ? 1 : 0.1)
                    .animation(.easeInOut(duration: 1.5), value: imageVisible)
                    .onAppear{imageVisible = true}

                Spacer()

                Text("Welcome to Bubble Pop!")
                    .font(.title)
                    .fontWeight(.heavy).foregroundColor(.skyblue)

                Spacer()

                NavigationLink(
                    destination: SettingsView(),
                    label: {
                        Text("New Game")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundStyle(.skyblue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                )
                .padding(.horizontal, 40)

                NavigationLink(
                    destination: HighScoreView(score: 0, playerName: ""),
                    label: {
                        Text("High Score")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundStyle(.skyblue)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                    }
                )
                .padding(.horizontal, 40)
                Spacer()
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    ContentView()
}
