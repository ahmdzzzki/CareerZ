//
//  OnboardingTopBar.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct OnboardingTopBar: View {
    
    let onBack: () -> Void
    let onSkip: () -> Void
    
    var body: some View {
        GlassEffectContainer(spacing: AppSpacing.md) {
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(.primary)
                .glassEffect(.regular.interactive(), in: .circle)
                
                Spacer()
                
                Button("Skip", action: onSkip)
                    .font(AppTypography.headline)
                    .buttonStyle(.plain)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, AppSpacing.md)
                    .frame(height: 44)
                    .glassEffect()
            }
        }
    }
}

#Preview {
    OnboardingTopBar(
        onBack: {},
        onSkip: {}
    )
    .padding()
    .background(Color.appGroupedBackground)
}
