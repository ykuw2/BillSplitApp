//
//  DetailedViewModel.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import SwiftUI

import Foundation
import SwiftUI

class DetailedViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var miscAmount: String = ""
    @Published var miscAmounts: [Double] = []
    @Published var newPersonName: String = ""
    @Published var newAmount: String = ""
    @Published var tipPercentageUse: Bool = true
    @Published var tipPercentage: Double = 15
    @Published var customTipAmount: String = ""
    @Published var billAmount: String = ""
    @Published var taxAmount: String = ""
    
    var totalAmountPreTip: Double {
        people.reduce(0) { $0 + $1.total }
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
    
    func addPerson() {
        guard !newPersonName.isEmpty else { return }
        let newPerson = Person(name: newPersonName, amounts: [])
        people.append(newPerson)
        newPersonName = ""
    }
    
    func addAmount(to person: inout Person) { // inout means can modify the original Person variable
        guard !person.amount.isEmpty, let value = Double(person.amount) else { return }
        person.amounts.append(value)
        person.amount = ""
    }
    
    func addMiscAmount() {
        guard !miscAmount.isEmpty, let value = Double(miscAmount) else { return }
        miscAmounts.append(value)
        miscAmount = ""
    }
}
