//
//  EqualViewModel.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import Foundation
import SwiftUI

class EqualViewModel: ObservableObject { // Use classes for Observable Objects
    @Published var billAmount: String = "" // Published is a property wrapper to conform to the ObservableObject - kind of like @State
    @Published var taxAmount: String = ""
    @Published var tipPercentageUse: Bool = true
    @Published var tipPercentage: Double = 15
    @Published var customTipAmount: String = ""
    @Published var numberOfPeople: Int = 2
    
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
        guard numberOfPeople > 0 else { return 0 }
        return total / Double(numberOfPeople)
    }
}
