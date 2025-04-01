//
//  ContentView.swift
//  PomodoroTimerWithTarget
//
//  Created by Firas Al-Doghman on 30/3/2024.
//Allowing users to set a countdown timer and enter a task description. 

import SwiftUI


struct ContentView: View {
    /**
     UI:
     @State Variables:
     countdownInSeconds: Represents the current countdown time in seconds.
     isCountingDown: Indicates whether the timer is currently counting down.
     countdownInput: Stores the input value from the slider as a string.
     @ObservedObject Variable:
     targetViewModel: An observed object of type TargetViewModel. This view model is observed for changes, and it typically holds the state and logic related to the target.
     */
    @State private var countdownInSeconds = 0
    @State private var isCountingDown = false
    @State private var countdownInput = ""
    
    @ObservedObject var targetViewModel = TargetViewModel()
    
    var body: some View {
        //NavigationLink: Allows navigation to the TargetView, passing the targetViewModel as its parameter.
        NavigationView {
            VStack {
                
               
                Text("Countdown: \(countdownInSeconds)")
                    .padding()
                
                //Text Field for Entering Task Description: A TextField where the user can enter the task description. The entered text is bound to the taskDescription property of the targetViewModel.
                TextField("Enter Task", text: $targetViewModel.taskDescription)
                    .padding()
                // TextField for entering the countdown value. It is bound to the countdownInput state variable and configured to accept numerical input using the number pad keyboard.
                TextField("Countdown Value", text: $countdownInput)
                    .padding()
                    .keyboardType(.numberPad)
                
                NavigationLink(destination: TargetView(viewModel: targetViewModel)) {
                    Text("View Target")
                        .padding()
                }
                //Start/Stop Button: A button that starts or stops the countdown timer based on the current state (isCountingDown). When the button is tapped, it either starts the countdown (if not already counting down) or stops it (if already counting down).
                Button(action: {
                    guard let input = Int(countdownInput) else { return }
                    countdownInSeconds = input
                    isCountingDown.toggle()
                    if isCountingDown {
                        startCountDown()
                    } else {
                        resetTimer()
                    }
                }) {
                    Text(isCountingDown ? "Stop" : "Start")
                        .padding()
                }
            }
            //Timer Logic: The countdown timer logic is implemented using Timer.publish. It decrements the countdownInSeconds variable every second if the timer is active (isCountingDown is true).
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                if isCountingDown {
                    onCountDown()
                }
            })
            //Lifecycle Events: The resetTimer() function is called when the view appears (onAppear), initializing the timer's state.
            .onAppear {
                resetTimer()
            }
        }
    }
    //Timer Control Functions:
    //startCountDown(): Starts the countdown timer. It creates a Task object using the task description from the targetViewModel and the countdown time from countdownInSeconds.
    
    func startCountDown() {
        let task = Task(description: targetViewModel.taskDescription, time: countdownInSeconds)
        print("Starting \(task)")
        isCountingDown = true
    }
    //resetTimer(): Resets the timer state, stopping the countdown and resetting the countdown time.
    func resetTimer() {
        isCountingDown = false
        countdownInSeconds = 0
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
    ContentView()
}
