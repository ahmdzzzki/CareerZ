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
            
            completionIllustration
            
            VStack(spacing: AppSpacing.md) {
                Text("Assessment\nCompleted")
                    .font(AppTypography.largeTitle.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Great job! We’ve tailored your career roadmap based on your profile.")
                    .font(AppTypography.body)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, AppSpacing.lg)
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
        .background(Color.appGroupedBackground)
        .accessibilityElement(children: .contain)
    }
    
    private var completionIllustration: some View {
        ZStack {
            Circle()
                .fill(Color.appPrimary.opacity(0.12))
                .frame(width: 190, height: 190)
                .blur(radius: 20)
            
            Circle()
                .fill(Color.appPrimary.opacity(0.10))
                .frame(width: 136, height: 136)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.appPrimary,
                            Color.appInfo
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 104, height: 104)
                .shadow(
                    color: Color.appPrimary.opacity(0.25),
                    radius: 18,
                    x: 0,
                    y: 10
                )
            
            Image(systemName: "checkmark")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .accessibilityHidden(true)
            
            Circle()
                .fill(Color.appSuccess.opacity(0.75))
                .frame(width: 18, height: 18)
                .offset(x: 68, y: -56)
                .accessibilityHidden(true)
            
            Circle()
                .fill(Color.appInfo.opacity(0.35))
                .frame(width: 14, height: 14)
                .offset(x: -76, y: 42)
                .accessibilityHidden(true)
        }
        .accessibilityLabel("Assessment completed")
    }
}

#Preview {
    AssessmentCompletedView()
}
