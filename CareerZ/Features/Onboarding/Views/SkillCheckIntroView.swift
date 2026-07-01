//
//  SkillCheckIntroView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct SkillCheckIntroView: View {

    @State private var showSkipAlert = false

    let selectedGoal: CareerGoalOption
    
    var onBack: () -> Void = {}
    var onSkip: () -> Void = {}
    var onStart: () -> Void = {}
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            
            OnboardingTopBar(
                onBack: onBack,
                onSkip: { showSkipAlert = true }
            )
            .alert("Career Profile Setup", isPresented: $showSkipAlert) {
                Button("Continue Setup", role: .cancel) { }
                Button("Skip", role: .destructive) {
                    onSkip()
                }
            } message: {
                Text("You can complete your career profile later from Settings.")
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xl) {
                    selectedGoalCard
                    introSection
                    benefitsSection
                }
                .padding(.top, AppSpacing.xs)
                .padding(.bottom, AppSpacing.xl)
            }
            
            AppButton(
                title: "Start",
                action: onStart,
                isEnabled: true
            )
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appGroupedBackground)
    }
    
    private var selectedGoalCard: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("You chose")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                
                Text(selectedGoal.title)
                    .font(AppTypography.title.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                
                Label("Goal Confirmed", systemImage: "checkmark.circle")
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appSuccess)
            }
            
            Spacer(minLength: AppSpacing.sm)
            
            Image(selectedGoal.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 116, height: 116)
                .accessibilityHidden(true)
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, minHeight: 156, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.xl, style: .continuous)
                .fill(Color.appCardBackground)
        }
        .overlay {
            RoundedRectangle(cornerRadius: AppRadius.xl, style: .continuous)
                .stroke(Color.appSeparator.opacity(0.35), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("You chose \(selectedGoal.title). Goal confirmed.")
    }
    
    private var introSection: some View {
        VStack(spacing: AppSpacing.sm) {
            Text("Skill Check")
                .font(AppTypography.title.bold())
                .foregroundStyle(Color.appTextPrimary)
            
            Text("Answer a few questions to personalize your career roadmap.")
                .font(AppTypography.body)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppSpacing.md)
    }
    
    private var benefitsSection: some View {
        VStack(spacing: AppSpacing.sm) {
            SkillCheckBenefitRow(
                systemImage: "clock",
                title: "Quick & Easy",
                subtitle: "Takes only a few minutes"
            )
            
            SkillCheckBenefitRow(
                systemImage: "scope",
                title: "Personalized Insights",
                subtitle: "Get tailored career insights"
            )
            
            SkillCheckBenefitRow(
                systemImage: "chart.bar",
                title: "Actionable Roadmap",
                subtitle: "Receive clear next steps"
            )
        }
        .padding(.horizontal, AppSpacing.xs)
    }
}

private struct SkillCheckBenefitRow: View {
    
    let systemImage: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: systemImage)
                .font(AppTypography.headline)
                .foregroundStyle(Color.appPrimary)
                .frame(width: 44, height: 44)
                .background {
                    RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                        .fill(Color.appPrimary.opacity(0.12))
                }
                .accessibilityHidden(true)
            
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                
                Text(subtitle)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.vertical, AppSpacing.xs)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}

#Preview {
    SkillCheckIntroView(
        selectedGoal: CareerGoalOption(
            title: "Product Manager",
            subtitle: "Strategy, Roadmaps & Delivery",
            systemImage: "briefcase",
            color: .blue,
            imageName: "productManager"
        )
    )
}
