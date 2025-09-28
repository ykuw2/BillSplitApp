//
//  ContentView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    @StateObject private var equalVM = EqualViewModel() // Use this StateObject to instatiate that Observable Object in parent view
    @StateObject private var detailedVM = DetailedViewModel() // SwiftUI keeps it alive as the view exists
    
    var body: some View {
        Picker("Mode", selection: $selection) {
            Text("Equal").tag(0)
            Text("Detailed").tag(1)
        }
        .pickerStyle(.segmented)
        .padding()
        
        if selection == 0 {
            EqualView(viewModel: equalVM)
        } else {
            DetailedView(viewModel: detailedVM)
        }
    }
}
    
#Preview {
    ContentView()
}
