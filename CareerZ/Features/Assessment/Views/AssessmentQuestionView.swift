//
//  AssessmentQuestionView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct AssessmentQuestionView: View {
    
    @State private var viewModel: AssessmentViewModel
    @State private var showSkipAlert = false

    var onBack: () -> Void
    var onSkip: () -> Void
    var onComplete: () -> Void
    
    init(
        goal: CareerGoalOption,
        onBack: @escaping () -> Void = {},
        onSkip: @escaping () -> Void = {},
        onComplete: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: AssessmentViewModel(goal: goal)
        )
        
        self.onBack = onBack
        self.onSkip = onSkip
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            
            OnboardingTopBar(
                onBack: {
                    if viewModel.currentQuestionIndex == 0 {
                        onBack()
                    } else {
                        viewModel.goBack()
                    }
                },
                onSkip: {
                    showSkipAlert = true
                }
            )
            .alert(
                "Career Profile Setup",
                isPresented: $showSkipAlert
            ) {
                Button("Continue Setup", role: .cancel) { }

                Button("Skip") {
                    onSkip()
                }
            } message: {
                Text("You can complete your career profile later from Settings.")
            }
                
            VStack(spacing: AppSpacing.xs) {
                HStack {
                    Text(viewModel.questionNumberText)
                        .font(AppTypography.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.progressText)
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }
                
                ProgressView(value: viewModel.progress)
                    .tint(.appPrimary)
            }
            
            Text(viewModel.currentQuestion.question)
                .font(AppTypography.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                    AssessmentOptionCard(
                        title: option,
                        isSelected: viewModel.selectedOption == option
                    ) {
                        viewModel.selectOption(option)
                    }
                }
            }
            
            Spacer()
            
            VStack(spacing: AppSpacing.xs) {
                AppButton(
                    title: viewModel.buttonTitle,
                    action: {
                        if viewModel.isLastQuestion {
                            onComplete()
                        } else {
                            viewModel.goNext()
                        }
                    },
                    isEnabled: viewModel.selectedOption != nil
                )
                
                if viewModel.isLastQuestion {
                    Text("Your career roadmap will be generated instantly.")
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appBackground)
    }
}

#Preview {
    AssessmentQuestionView(
        goal: CareerGoalOption(
            title: "Product Manager",
            subtitle: "Strategy, Roadmaps & Delivery",
            systemImage: "briefcase.fill",
            color: .blue,
            imageName: "productManager"
        )
    )
}
