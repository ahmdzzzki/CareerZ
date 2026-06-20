//
//  SkillCheckIntroView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct SkillCheckIntroView: View {
    
    let selectedGoal: CareerGoalOption
    
    var onBack: () -> Void = {}
    var onSkip: () -> Void = {}
    var onStart: () -> Void = {}
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            
            OnboardingTopBar(
                onBack: onBack,
                onSkip: onSkip
            )
            
            VStack(spacing: AppSpacing.xl) {
                selectedGoalCard
                
                VStack(spacing: AppSpacing.xs) {
                    Text("Skill Check")
                        .font(AppTypography.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Answer a few questions to personalize your career roadmap.")
                        .font(AppTypography.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: AppSpacing.md) {
                    SkillCheckBenefitRow(
                        systemImage: "clock.fill",
                        title: "Quick & Easy",
                        subtitle: "Takes only a few minutes"
                    )
                    
                    SkillCheckBenefitRow(
                        systemImage: "scope",
                        title: "Personalized Insights",
                        subtitle: "Get tailored career insights"
                    )
                    
                    SkillCheckBenefitRow(
                        systemImage: "chart.bar.fill",
                        title: "Actionable Roadmap",
                        subtitle: "Receive clear next steps"
                    )
                }
            }
            
            Spacer()
            
            AppButton(
                title: "Start",
                action: onStart,
                isEnabled: true
            )
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appBackground)
    }
    
    private var selectedGoalCard: some View {
        HStack(spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("You chose")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(selectedGoal.title)
                    .font(AppTypography.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                Label("Goal Confirmed", systemImage: "checkmark.circle.fill")
                    .font(AppTypography.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.green)
            }
            
            Spacer(minLength: AppSpacing.sm)
            
            Image(selectedGoal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
        }
        .padding(AppSpacing.lg)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl, style: .continuous)
                .fill(.regularMaterial)
        }
    }
}

private struct SkillCheckBenefitRow: View {
    
    let systemImage: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)
                .frame(width: 40, height: 40)
                .background(
                    Color.appPrimary.opacity(0.14),
                    in: RoundedRectangle(
                        cornerRadius: AppRadius.md,
                        style: .continuous
                    )
                )
            
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SkillCheckIntroView(
        selectedGoal: CareerGoalOption(
            title: "Product Manager",
            subtitle: "Strategy, Roadmaps & Delivery",
            systemImage: "briefcase.fill",
            color: .blue,
            imageName: "productManager"
        )
    )
}
