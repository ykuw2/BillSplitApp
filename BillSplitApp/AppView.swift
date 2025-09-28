//
//  AppView.swift
//  BillSplitApp
//
//  Created by Yuki Kuwahara on 9/28/25.
//

import SwiftUI

struct AppView: View {
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            WelcomeView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showSplash = false
                        }
                    }
                }
        } else {
            ContentView()
        }
    }
}
