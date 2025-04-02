//
//  ContentView.swift
//  bubbles
//
//  Created by Jan Huecking on 2/4/2025.
//

import SwiftUI

struct Bubble: View {
    @State private var value: Double = 0
    @State private var scale: CGFloat = 1.0
    @State private var color: Color = .yellow  // Default color
    @State private var isVisible: Bool = true
    
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
            .opacity(isVisible ? 1 : 0)
            .onTapGesture {
                disappearBubble()
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
    
    private func disappearBubble() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
            scale = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            withAnimation {
                isVisible = false
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Bubble()
            Bubble()
        }
    }
}

#Preview {
    ContentView()
}
