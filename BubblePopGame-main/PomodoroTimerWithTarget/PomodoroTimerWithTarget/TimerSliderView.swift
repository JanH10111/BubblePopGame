//
//  TimerSliderView.swift
//  PomodoroTimerWithTarget
//
//  Created by Firas Al-Doghman on 30/3/2024.
//This view includes UI elements for setting a countdown timer using a slider and interacting with the timer using buttons.

import SwiftUI

struct TimerSliderView: View {
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
    @State private var countdownValue: Double = 0
    @ObservedObject var targetViewModel = TargetViewModel()
    
    var body: some View {
        //NavigationLink: Allows navigation to the TargetView, passing the targetViewModel as its parameter
        NavigationView {
            VStack {
                Text("Countdown: \(countdownInSeconds)")
                    .padding()
                
               //Text Field for Entering Task Description: A TextField where the user can enter the task description. The entered text is bound to the taskDescription property of the targetViewModel.
                TextField("Enter Name", text: $targetViewModel.taskDescription)
                    .padding()
                
                Text("Timer")
                //Slider for Setting Timer: A Slider component is used to set the timer value. It allows the user to select a value between 0 and 60, representing the countdown time in seconds.
                Slider(value: $countdownValue, in: 0...60, step: 1)
                    .padding()
                    .onChange(of: countdownValue, perform: { value in
                        countdownInput = "\(Int(value))"
                    })
                //Text Displaying Timer Value: Displays the current value selected on the slider, representing the countdown time in seconds.
                Text(" \(Int(countdownValue))")
                    .padding()

                
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
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: { _ in
                if isCountingDown {
                    onCountDown()
                }
            })
            //Timer Logic:The countdown timer logic is implemented using Timer.publish. It decrements the countdownInSeconds variable every second if the timer is active (isCountingDown is true).
            .onAppear {
                resetTimer()
            }
            //Lifecycle Events: The resetTimer() function is called when the view appears (onAppear), initializing the timer's state.
        }
    }
    
    //Timer Control Functions:
    //startCountDown(): Starts the countdown timer. It creates a Task object using the task description from the targetViewModel and the countdown time from countdownInSeconds.
   
    func startCountDown() {
        let task = Task(description: targetViewModel.taskDescription, time: countdownInSeconds)
        print("Starting \(task)")
        isCountingDown = true
    }
    // resetTimer(): Resets the timer state, stopping the countdown and resetting the countdown time.
    
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
    TimerSliderView()
}
