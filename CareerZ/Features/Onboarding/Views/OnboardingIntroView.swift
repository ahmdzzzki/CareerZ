//
//  OnboardingIntroView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct OnboardingIntroView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var onGetStarted: () -> Void = {}
    
    private var logoName: String {
        colorScheme == .dark ? "LogoCareerZFullPolos" : "LogoCareerZFull"
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            
            Spacer()
            
            VStack(spacing: AppSpacing.lg) {
                Image(logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .accessibilityLabel("CareerZ")
                
                Image("OnboardingIntro")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 325)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: AppRadius.xl,
                            style: .continuous
                        )
                    )
                    .accessibilityHidden(true)
            }
            
            VStack(spacing: AppSpacing.sm) {
                Text("Navigate Your Career Journey")
                    .font(AppTypography.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                
                Text("Discover opportunities, build the right skills, and take meaningful steps toward your career goals.")
                    .font(AppTypography.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, AppSpacing.xxl)
            
            Spacer()
            
            AppButton(
                title: "Get Started",
                action: onGetStarted
            )
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.bottom, AppSpacing.md)
        }
        .background(Color.appBackground)
    }
}

#Preview {
    OnboardingIntroView()
}
