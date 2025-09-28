//
//  WelcomeView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("WelcomeIcon")
                .resizable()
                .frame(width: 80, height: 80)
            
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
