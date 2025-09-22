//
//  ContentView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/15/25.
//

import Foundation
import SwiftUI

// This is the Main View

struct ContentView: View {
    @State private var selection = 0 // Default to 0 for equal split
    
    var body: some View {
        NavigationStack{
            Picker("Mode", selection: $selection) {
                Text("Equal").tag(0)
                Text("Detailed").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()
            .navigationTitle("Bill Split Application")
            .navigationBarTitleDisplayMode(.inline)
            
            // Switch between views
            if selection == 0 {
                EqualView()
            } else {
                // DetailedView()
            }
        }
    }
}

// Equal Split View

struct EqualView: View {
    @State private var billAmount: String = ""
    @State private var tipPercentageUse: Bool = true
    @State private var tipPercentage: Double = 15
    @State private var customTipAmount: String = ""
    @State private var numberOfPeople: Int = 2
    
    var total: Double {
        let bill = Double(billAmount) ?? 0 // nil-coalescing (if nil use 0)
        var tip: Double {
            if tipPercentageUse {
                return bill * (tipPercentage / 100)
            } else {
                return Double(customTipAmount) ?? 0
            }
        }
        return bill + tip
    }
    
    var perPerson: Double {
        total / Double(numberOfPeople) // Double here since type-safe
    }
    
    var body: some View {
            Form {
                Section(header: Text("Bill Details")) {
                    HStack {
                        Text("$")
                        TextField("Enter bill amount", text: $billAmount)
                            .keyboardType(.decimalPad)
                            .toolbar {
                                ToolbarItemGroup(placement: .keyboard) { // Place it on keyboard
                                    Spacer() // Flexble space before the button, pushes it to the right
                                    Button("Done") {
                                        UIApplication.shared.sendAction( // Sending the action to the UI
                                            #selector(UIResponder.resignFirstResponder), // Resign the first responder - the text field
                                            to: nil, from: nil, for: nil // Send to any object that can respond
                                        )
                                    }
                                }
                            }
                    }
                    .padding(.vertical)
                    
                    // The $billAmount here creates a binding effect to the @State so whenever
                    // a user inputs an amount it will update in the UI)'
                    Picker("Tip Type", selection: $tipPercentageUse) {
                        Text("Percentage").tag(true)
                        Text("Custom Amount").tag(false)
                    }
                    .padding(.vertical)
                    
                    if tipPercentageUse {
                        HStack {
                            Text("Tip: \(Int(tipPercentage))%")
                            Slider(value: $tipPercentage, in: 0...30, step: 1)
                        }
                        .padding(.vertical)
                    } else {
                        HStack{
                            Text("$")
                            TextField("Enter custom tip", text: $customTipAmount)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.vertical)
                    }
                    
                    Stepper("Total number of people: \(numberOfPeople)", value: $numberOfPeople, in: 1...20)
                        .padding(.vertical)
                    
                }
                Section(header: Text("Bill Total")) {
                    Text("Total: $\(total, specifier: "%.2f")")
                        .padding(.vertical)
                    Text("Per Person: $\(perPerson, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.vertical)
                }
            }
        }
    }

// Detailed Split View Structs

struct Person: Identifiable {
    let id = UUID()
    var name: String
    //var items: [Item]
}

struct Item: Identifiable {
    let id: UUID
    var name: String
    var price: Double
}

// Detailed Split View

//struct DetailedView(): View{
//    var body: some View {
//        
//    }
//}

#Preview {
    ContentView()
}
