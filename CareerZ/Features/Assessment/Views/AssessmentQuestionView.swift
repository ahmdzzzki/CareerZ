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
        _viewModel = State(initialValue: AssessmentViewModel(goal: goal))
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
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.goBack()
                        }
                    }
                },
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
            
            progressSection
            
            Text(viewModel.currentQuestion.question)
                .font(AppTypography.title2.bold())
                .foregroundStyle(Color.appTextPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.currentQuestion.options, id: \.self) { option in
                    AssessmentOptionCard(
                        title: option,
                        isSelected: viewModel.selectedOption == option
                    ) {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            viewModel.selectOption(option)
                        }
                    }
                }
            }
            .padding(.horizontal, 2)
            
            Spacer()
            
            bottomAction
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appSecondaryBackground)
        .animation(.easeInOut(duration: 0.28), value: viewModel.progress)
        .animation(.easeInOut(duration: 0.22), value: viewModel.currentQuestionIndex)
    }
    
    private var progressSection: some View {
        VStack(spacing: AppSpacing.xs) {
            HStack {
                Text(viewModel.questionNumberText)
                    .font(AppTypography.headline)
                    .foregroundStyle(Color.appTextPrimary)
                
                Spacer()
                
                Text(viewModel.progressText)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }
            
            ProgressView(value: viewModel.progress)
                .tint(Color.appPrimary)
                .animation(.easeInOut(duration: 0.35), value: viewModel.progress)
                .accessibilityLabel("Assessment progress")
                .accessibilityValue(viewModel.progressText)
        }
    }
    
    private var bottomAction: some View {
        VStack(spacing: AppSpacing.xs) {
            AppButton(
                title: viewModel.buttonTitle,
                action: {
                    withAnimation(.easeInOut(duration: 0.28)) {
                        if viewModel.isLastQuestion {
                            onComplete()
                        } else {
                            viewModel.goNext()
                        }
                    }
                },
                isEnabled: viewModel.selectedOption != nil
            )
            
            if viewModel.isLastQuestion {
                Text("Your career roadmap will be generated instantly.")
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
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
