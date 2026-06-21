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
        Group {
            switch step {
            case .splash:
                splashView
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            step = .intro
                        }
                    }
                
            case .intro:
                OnboardingIntroView {
                    step = .goal
                }
                
            case .goal:
                GoalSelectionView(
                    onBack: { step = .intro },
                    onSkip: {
                        onFinished()
                    },
                    onContinue: { goal in
                        selectedGoal = goal
                        step = .skillCheck
                    }
                )
                
            case .skillCheck:
                if let selectedGoal {
                    SkillCheckIntroView(
                        selectedGoal: selectedGoal,
                        onBack: { step = .goal },
                        onSkip: {
                            onFinished()
                        },
                        onStart: { step = .assessment }
                    )
                }
                
            case .assessment:
                if let selectedGoal {
                    AssessmentQuestionView(
                        goal: selectedGoal,
                        onBack: { step = .skillCheck },
                        onSkip: {
                            onFinished()
                        },
                        onComplete: { step = .completed }
                    )
                }
                
            case .completed:
                AssessmentCompletedView(
                    onGoHome: onFinished
                )
            }
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
                
                Text("CareerZ")
                    .font(AppTypography.largeTitle)
                    .fontWeight(.bold)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    OnboardingView()
}
