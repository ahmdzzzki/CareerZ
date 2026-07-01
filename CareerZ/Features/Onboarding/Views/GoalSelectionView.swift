//
//  GoalSelectionView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct GoalSelectionView: View {
    
    @State private var viewModel = GoalSelectionViewModel()
    @State private var showSkipAlert = false
    @FocusState private var isSearchFocused: Bool
    
    var onBack: () -> Void = {}
    var onSkip: () -> Void = {}
    var onContinue: (CareerGoalOption) -> Void = { _ in }
    
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
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text("What’s your goal?")
                    .font(AppTypography.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.appTextPrimary)
                
                Text("Select your target career path to personalize your roadmap and opportunities.")
                    .font(AppTypography.body)
                    .foregroundStyle(Color.appTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            AppSearchField(
                text: $viewModel.searchText,
                prompt: "Search",
                isFocused: $isSearchFocused
            )
            
            ScrollView {
                VStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.filteredGoals) { goal in
                        GoalOptionCard(
                            goal: goal,
                            isSelected: viewModel.selectedGoal == goal
                        ) {
                            isSearchFocused = false
                            viewModel.selectGoal(goal)
                        }
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, AppSpacing.xs)
                .padding(.bottom, AppSpacing.md)
            }
            .scrollDismissesKeyboard(.interactively)
            
            AppButton(
                title: "Continue",
                action: {
                    isSearchFocused = false
                    
                    if let selectedGoal = viewModel.selectedGoal {
                        onContinue(selectedGoal)
                    }
                },
                isEnabled: viewModel.canContinue
            )
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.sm)
        .background(Color.appGroupedBackground)
        .onTapGesture {
            isSearchFocused = false
        }
    }
}

#Preview {
    GoalSelectionView()
}
