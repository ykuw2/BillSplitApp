//
//  Person.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import Foundation
import SwiftUI

struct Person: Identifiable {
    let id = UUID()
    var name: String
    var amount : String = ""
    var amounts: [Double]
    
    var total: Double {
        amounts.reduce(0, +)
    }
}
