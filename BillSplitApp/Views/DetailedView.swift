//
//  DetailedView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import SwiftUI

struct DetailedView: View {
    @ObservedObject var viewModel: DetailedViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Add Person")) {
                HStack {
                    TextField("Name", text: $viewModel.newPersonName)
                    Button(action: {
                        viewModel.addPerson()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            ForEach(viewModel.people.indices, id: \.self) { i in
                Section(header: Text(viewModel.people[i].name)) {
                    HStack {
                        Text("$")
                        TextField("Enter Amount", text: $viewModel.people[i].amount)
                            .keyboardType(.decimalPad)
                        Button(action: {
                            viewModel.addAmount(to: &viewModel.people[i]) // & here is passing a varuabke as an inout parameter
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    ForEach(viewModel.people[i].amounts.indices, id: \.self) { j in
                        HStack {
                            Text("Item \(j + 1)")
                            Spacer()
                            Text("$\(viewModel.people[i].amounts[j], specifier: "%.2f")")
                        }
                    }
                    .onDelete { offsets in
                        viewModel.people[i].amounts.remove(atOffsets: offsets)
                    }
                }
            }
            .onDelete { offsets in
                viewModel.people.remove(atOffsets: offsets)
            }
            
            Section(header: Text("Miscellanous")) {
                HStack {
                    Text("$")
                    TextField("Enter Amount", text: $viewModel.miscAmount)
                        .keyboardType(.decimalPad)
                    Button(action: {
                        viewModel.addMiscAmount()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                ForEach(viewModel.miscAmounts.indices, id: \.self) { i in
                    HStack {
                        Text("Misc \(i + 1)")
                        Spacer()
                        Text("$\(viewModel.miscAmounts[i], specifier: "%.2f")")
                    }
                }
                .onDelete { offsets in
                    viewModel.miscAmounts.remove(atOffsets: offsets)
                }
            }
            
            Section(header: Text("Tax")) {
                HStack {
                    Text("$")
                    TextField("Enter tax amount", text: $viewModel.taxAmount)
                        .keyboardType(.decimalPad)
                }
            }
             
            Section(header: Text("Tip Amount")) {
                Picker("Tip Type", selection: $viewModel.tipPercentageUse) {
                    Text("Percentage").tag(true)
                    Text("Custom Amount").tag(false)
                }
                
                if viewModel.tipPercentageUse {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Tip: \(Int(viewModel.tipPercentage))%")
                            Slider(value: $viewModel.tipPercentage, in: 0...30, step: 1)
                        }
                        Text("Tip Amount: $\(viewModel.tipAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical)
                } else {
                    HStack{
                        Text("$")
                        TextField("Enter custom tip", text: $viewModel.customTipAmount)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            
            Section(header: Text("Bill Total and Splits")) {
                Text("Total: $\(viewModel.totalAmount, specifier:"%.2f")")
                ForEach(viewModel.people.indices, id: \.self) { i in
                    let personSplit = viewModel.finalAmount(for: viewModel.people[i])
                    Text("\(viewModel.people[i].name): $\(personSplit, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
        }
        .toolbar {
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
