//
//  TargetView.swift
//  PomodoroTimerWithTarget
//
//  Created by Firas Al-Doghman on 30/3/2024.
//

import SwiftUI

struct TargetView: View {
    @ObservedObject var viewModel: TargetViewModel
    
    var body: some View {
        Text("Task Description: \(viewModel.taskDescription)")
            .padding()
    }
}

#Preview {
    TargetView(viewModel: TargetViewModel())
}
