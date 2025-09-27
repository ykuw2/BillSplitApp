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
        Picker("Mode", selection: $selection) {
            Text("Equal").tag(0)
            Text("Detailed").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            // Switch between views
            if selection == 0 {
                EqualView()
            } else {
                DetailedView()
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
    var amount : String = ""
    var amounts: [Double]
    
    var total: Double {
        amounts.reduce(0, +)
    }
}

// Detailed Split View

struct DetailedView : View {
    @State private var people: [Person] = [] // starting empty
    @State private var newPersonName: String = ""
    @State private var newAmount = ""
    @State private var tipPercentageUse: Bool = true
    @State private var tipPercentage: Double = 15
    @State private var customTipAmount: String = ""
    @State private var billAmount: String = ""
    
    var totalAmountPreTip: Double {
        guard !people.isEmpty else { return 0.0 }
        
        var bill: Double {
            people.reduce(0) { $0 + $1.total }
        }
        
        return bill
        
    }
    
    var tipAmount: Double {
        if tipPercentageUse {
            return totalAmountPreTip * tipPercentage / 100
        } else {
            return Double(customTipAmount) ?? 0
        }
    }
    
    func tipShare(for person: Person) -> Double {
        let total = totalAmountPreTip
        guard total > 0 else { return 0.0 }
        let ratio = person.total / total
        
        return ratio
    }
    
    var totalAmount: Double {
        return totalAmountPreTip + tipAmount
    }
    
    
    var body: some View {
        Form {
            // Adding People
            Section(header: Text("Add Person")) {
                HStack {
                    TextField("Name", text: $newPersonName)
                    Button(action: {
                        guard !newPersonName.isEmpty else { return }
                        let newPerson = Person(name: newPersonName, amounts: [])
                        people.append(newPerson)
                        newPersonName = ""
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            // Person Section
            ForEach(people.indices, id: \.self) { i in
                Section(header: Text(people[i].name)) {
                    HStack {
                        TextField("Enter Amount", text: $people[i].amount)
                            .keyboardType(.decimalPad)
                        Button(action: {
                            guard !people[i].amount.isEmpty else { return }
                            if let value = Double(people[i].amount) {
                                people[i].amounts.append(value)
                                people[i].amount = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // Amounts Section
                    ForEach(people[i].amounts.indices, id: \.self) { j in
                        HStack {
                            Text("Item \(j + 1)")
                            Spacer()
                            Text("$\(people[i].amounts[j], specifier: "%.2f")")
                        }
                        
                    }.onDelete { offsets in
                        people[i].amounts.remove(atOffsets: offsets)
                    }
                }
                                
            }
            
            Section(header: Text("Tip Amount")) {
                Picker("Tip Type", selection: $tipPercentageUse) {
                    Text("Percentage").tag(true)
                    Text("Custom Amount").tag(false)
                }
                
                if tipPercentageUse {
                    HStack {
                        Text("Tip: \(Int(tipPercentage))%")
                        Slider(value: $tipPercentage, in: 0...30, step: 1)
                    }
                } else {
                    HStack{
                        Text("$")
                        TextField("Enter custom tip", text: $customTipAmount)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            Section(header: Text("Bill Total and Splits")) {
                Text("Total: $\(totalAmount, specifier:"%.2f")")
                
                ForEach(people.indices, id:\.self) { i in
                    let tipRatio: Double = tipShare(for: people[i])
                    let personSplit: Double = (tipAmount * tipRatio) + people[i].total
                    Text("\(people[i].name): $\(personSplit, specifier: "%.2f")")
                    
                }
            }
        }
        }
        
    }
    
#Preview {
    ContentView()
}
