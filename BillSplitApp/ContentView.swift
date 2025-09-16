//
//  ContentView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var billAmount: String = ""
    @State private var tipPercentage: Double = 15
    
    var body: some View {
        VStack(spacing: 20) { // 20 points of space between each child view
            Text("Tip Calculator")
                .font(.largeTitle)
            
            TextField("Enter bill amount", text: $billAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding()
            // The $billAmount here creates a binding effect to the @State so whenever
            // a user inputs an amount it will update in the UI)'
            
            HStack {
                Text("Tip: \(Int(tipPercentage))%")
                Slider(value: $tipPercentage, in: 0...30, step: 1)
            }
            .padding()
        }
        .padding()
    }
}

// Step 2 completed

#Preview {
    ContentView()
}
