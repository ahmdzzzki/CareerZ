//
//  OnboardingPageIndicator.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct OnboardingPageIndicator: View {
    
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.secondary : Color.secondary.opacity(0.25))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}
