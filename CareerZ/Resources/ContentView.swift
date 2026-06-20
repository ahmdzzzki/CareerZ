//
//  ContentView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 19/06/26.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView {
                    hasCompletedOnboarding = true
                }
            }
        }
        .onAppear {
            hasCompletedOnboarding = false
        }
    }
}

#Preview {
    ContentView()
}
