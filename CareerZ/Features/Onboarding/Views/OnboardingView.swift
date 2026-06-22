//
//  OnboardingView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct OnboardingView: View {
    
    var onFinished: () -> Void = {}
    
    @State private var step: OnboardingStep = .splash
    @State private var selectedGoal: CareerGoalOption?
    
    enum OnboardingStep {
        case splash
        case intro
        case goal
        case skillCheck
        case assessment
        case completed
    }
    
    var body: some View {
        ZStack {
            currentStepView
                .id(step)
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.98)),
                        removal: .opacity
                    )
                )
        }
        .animation(.easeInOut(duration: 0.45), value: step)
    }
    
    @ViewBuilder
    private var currentStepView: some View {
        switch step {
        case .splash:
            splashView
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            step = .intro
                        }
                    }
                }
            
        case .intro:
            OnboardingIntroView {
                withAnimation(.easeInOut(duration: 0.3)) {
                    step = .goal
                }
            }
            
        case .goal:
            GoalSelectionView(
                onBack: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        step = .intro
                    }
                },
                onSkip: { onFinished() },
                onContinue: { goal in
                    selectedGoal = goal
                    withAnimation(.easeInOut(duration: 0.3)) {
                        step = .skillCheck
                    }
                }
            )
            
        case .skillCheck:
            if let selectedGoal {
                SkillCheckIntroView(
                    selectedGoal: selectedGoal,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            step = .goal
                        }
                    },
                    onSkip: { onFinished() },
                    onStart: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            step = .assessment
                        }
                    }
                )
            }
            
        case .assessment:
            if let selectedGoal {
                AssessmentQuestionView(
                    goal: selectedGoal,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            step = .skillCheck
                        }
                    },
                    onSkip: { onFinished() },
                    onComplete: {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            step = .completed
                        }
                    }
                )
            }
            
        case .completed:
            AssessmentCompletedView(
                onGoHome: onFinished
            )
        }
    }
    
    private var splashView: some View {
        ZStack {
            Color.appPrimary
                .ignoresSafeArea()
            
            HStack(spacing: AppSpacing.sm) {
                Image("LogoCareerZPolos")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
                    .accessibilityHidden(true)
                
                Text("CareerZ")
                    .font(AppTypography.largeTitle.bold())
            }
            .foregroundStyle(.white)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("CareerZ")
        }
    }
}

#Preview {
    OnboardingView()
}
