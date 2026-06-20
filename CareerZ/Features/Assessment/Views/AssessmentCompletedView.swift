//
//  AssessmentCompletedView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct AssessmentCompletedView: View {
    
    var onGoHome: () -> Void = {}
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.14))
                    .frame(width: 190, height: 190)
                    .blur(radius: 18)
                
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appPrimary,
                                Color.teal
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 112, height: 112)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 46, weight: .bold))
                    .foregroundStyle(.white)
                
                Circle()
                    .fill(Color.green.opacity(0.75))
                    .frame(width: 24, height: 24)
                    .offset(x: 70, y: -58)
                
                Circle()
                    .fill(Color.cyan.opacity(0.45))
                    .frame(width: 16, height: 16)
                    .offset(x: -82, y: 40)
            }
            
            VStack(spacing: AppSpacing.md) {
                Text("Assessment\nCompleted")
                    .font(AppTypography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Great job! We’ve tailored your career roadmap based on your profile.")
                    .font(AppTypography.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
            }
            
            Spacer()
            
            AppButton(
                title: "Go to Home Dashboard",
                action: onGoHome,
                isEnabled: true
            )
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appBackground)
    }
}

#Preview {
    AssessmentCompletedView()
}
