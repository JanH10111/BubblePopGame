//
//  ContentView.swift
//  BubblePopGame
//
//  Created by Jan Huecking on 1/4/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                Label("Bubble Pop", systemImage: "")
                    .foregroundStyle(.mint)
                    .font(.largeTitle)
                
                Spacer()
                
                NavigationLink(destination: SettingsView(),
                               label: {
                    Text("New Game")
                        .font(.title)
                })
                .padding(50)
                
                NavigationLink(destination: HighScoreView(score: 0),
                               label: {
                    Text("High Score")
                        .font(.title)
                })
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
