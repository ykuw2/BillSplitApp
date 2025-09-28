//
//  EqualView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import SwiftUI

struct EqualView: View {
    @ObservedObject var viewModel: EqualViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Bill Details")) {
                HStack {
                    Text("Total: $")
                    TextField("Enter total bill amount", text: $viewModel.billAmount)
                        .keyboardType(.decimalPad)
                }.padding(.vertical)
                
                Picker("Tip Type", selection: $viewModel.tipPercentageUse) {
                    Text("Percentage").tag(true)
                    Text("Custom Amount").tag(false)
                }
                .padding(.vertical)
                
                if viewModel.tipPercentageUse {
                    HStack {
                        Text("Tax: $")
                        TextField("Enter to exclude from calculation", text: $viewModel.taxAmount)
                            .keyboardType(.decimalPad)
                    }
                    .padding(.vertical)
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
                        Text("Tip: $")
                        TextField("Enter custom tip", text: $viewModel.customTipAmount)
                            .keyboardType(.decimalPad)
                    }
                    .padding(.vertical)
                }
                
                Stepper("Total number of people: \(viewModel.numberOfPeople)", value: $viewModel.numberOfPeople, in: 1...20)
                    .padding(.vertical)
            }
            Section(header: Text("Bill Total")) {
                Text("Total: $\(viewModel.total, specifier: "%.2f")")
                    .padding(.vertical)
                Text("Per Person: $\(viewModel.perPerson, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.vertical)
            }
        }
        .scrollDisabled(true)
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
