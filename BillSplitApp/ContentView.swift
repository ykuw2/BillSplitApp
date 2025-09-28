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
    @State private var taxAmount: String = ""
    @State private var tipPercentageUse: Bool = true
    @State private var tipPercentage: Double = 15
    @State private var customTipAmount: String = ""
    @State private var numberOfPeople: Int = 2
    

    var tipAmount: Double {
        let bill = Double(billAmount) ?? 0
        let tax = Double(taxAmount) ?? 0
        if tipPercentageUse {
            return (bill - tax) * (tipPercentage / 100)
        } else {
            return Double(customTipAmount) ?? 0
        }
    }
    
    var total: Double {
        let bill = Double(billAmount) ?? 0
        return bill + tipAmount
    }
    
    
    var perPerson: Double {
        total / Double(numberOfPeople) // Double here since type-safe
    }
    
    var body: some View {
            Form {
                Section(header: Text("Bill Details")) {
                    HStack {
                        Text("Total: $")
                        TextField("Enter total bill amount", text: $billAmount)
                            .keyboardType(.decimalPad)
                    }.padding(.vertical)
                    
                    // The $billAmount here creates a binding effect to the @State so whenever
                    // a user inputs an amount it will update in the UI)
                    Picker("Tip Type", selection: $tipPercentageUse) {
                        Text("Percentage").tag(true)
                        Text("Custom Amount").tag(false)
                    }
                    .padding(.vertical)
                    
                    if tipPercentageUse {
                        HStack {
                            Text("Tax: $")
                            TextField("Enter to exclude from calculation", text: $taxAmount)
                                .keyboardType(.decimalPad)
                        }
                        .padding(.vertical)
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Tip: \(Int(tipPercentage))%")
                                Slider(value: $tipPercentage, in: 0...30, step: 1)
                            }
                            Text("Tip Amount: $\(tipAmount, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical)
                    } else {
                        HStack{
                            Text("Tip: $")
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
            .scrollDisabled(true)
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
    @State private var miscAmount: String = ""
    @State private var miscAmounts: [Double] = []
    @State private var newPersonName: String = ""
    @State private var newAmount = ""
    @State private var tipPercentageUse: Bool = true
    @State private var tipPercentage: Double = 15
    @State private var customTipAmount: String = ""
    @State private var billAmount: String = ""
    @State private var taxAmount: String = ""
    
    var totalAmountPreTip: Double {
        people.reduce(0) { $0 + $1.total } // Only sum people's items here
    }
    
    var tipAmount: Double {
        if tipPercentageUse {
            let miscAmountDouble: Double = miscAmounts.reduce(0, +)
            return (totalAmountPreTip + miscAmountDouble) * (tipPercentage / 100)
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
    
    func finalAmount(for person: Person) -> Double {
        let ratio = tipShare(for: person)
        let personTip = tipAmount * ratio
        let personTax = (Double(taxAmount) ?? 0) * ratio
        let personMisc = miscAmounts.reduce(0, +) * ratio
        
        return person.total + personTip + personTax + personMisc
    }
    
    var totalAmount: Double {
        let taxAmountDouble = Double(taxAmount) ?? 0
        let miscTotal = miscAmounts.reduce(0, +)
        return totalAmountPreTip + tipAmount + taxAmountDouble + miscTotal
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
                        Text("$")
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
                
            }.onDelete { offsets in
                people.remove(atOffsets: offsets)
            }
            
            Section(header: Text("Miscellanous")) {
                HStack {
                    Text("$")
                    TextField("Enter Amount", text: $miscAmount)
                        .keyboardType(.decimalPad)
                    Button(action: {
                        guard !miscAmount.isEmpty else { return }
                        if let value = Double(miscAmount) {
                            miscAmounts.append(value)
                            miscAmount = ""
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                
                ForEach(miscAmounts.indices, id: \.self) { i in
                    HStack {
                        Text("Misc \(i + 1)")
                        Spacer()
                        Text("$\(miscAmounts[i], specifier: "%.2f")")
                    }
                }.onDelete { offsets in
                    miscAmounts.remove(atOffsets: offsets)
                }
            }
            
            Section(header: Text("Tax")) {
                HStack {
                    Text("$")
                    TextField("Enter tax amount", text: $taxAmount)
                        .keyboardType(.decimalPad)
                }
            }
             
            Section(header: Text("Tip Amount")) {
                Picker("Tip Type", selection: $tipPercentageUse) {
                    Text("Percentage").tag(true)
                    Text("Custom Amount").tag(false)
                }
                
                if tipPercentageUse {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Tip: \(Int(tipPercentage))%")
                            Slider(value: $tipPercentage, in: 0...30, step: 1)
                        }
                        Text("Tip Amount: $\(tipAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)
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
                
                ForEach(people.indices, id: \.self) { i in
                    let personSplit = finalAmount(for: people[i])
                    Text("\(people[i].name): $\(personSplit, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil, from: nil, for: nil
                    )
                }
            }
        }
    }
        
    }

// WelcomeView - the view that plays when user first opens the app
struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("AppIcon")
                .font(.system(size: 80))
            
            Text("Bill Splitter")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text("Welcome")
                .font(.title2)
                .foregroundColor(.secondary)
        }
        .background(Color(.systemBackground))
    }
}

// Main app controller
struct AppView: View {
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            WelcomeView()
                .onAppear { // Modifier that runs code when this view appears on the screen
                    // Wait 2 seconds then transition
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // DispatchQueue schedules a closure to run after a delay
                        withAnimation(.easeInOut(duration: 0.5)) { // Run a smooth transition animation of 0.5 seconds
                            showSplash = false // Set to false to go to the main app
                        }
                    }
                }
        } else {
            ContentView() 
        }
    }
}
    
#Preview {
    ContentView()
}
