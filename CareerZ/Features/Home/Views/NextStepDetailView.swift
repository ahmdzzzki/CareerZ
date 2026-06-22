//
//  NextStepDetailView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct NextStepDetailView: View {

    @State private var viewModel: NextStepDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var assessmentFlowStep: AssessmentFlowStep?

    var onGoHome: () -> Void = {}

    enum AssessmentFlowStep: Identifiable {
        case questions
        case completed

        var id: Self { self }
    }

    init(
        nextStep: NextStep = .sample,
        careerGoal: CareerGoalOption = .sampleProductManager,
        onGoHome: @escaping () -> Void = {}
    ) {
        _viewModel = State(
            initialValue: NextStepDetailViewModel(
                nextStep: nextStep,
                careerGoal: careerGoal
            )
        )
        self.onGoHome = onGoHome
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.sectionSpacing) {
                header
                overviewCard
                topicsSection
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, 120)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            sheetHeader
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            bottomButton
        }
        .background(Color.appSecondaryBackground)
        .fullScreenCover(item: $assessmentFlowStep) { step in
            switch step {
            case .questions:
                AssessmentQuestionView(
                    goal: viewModel.careerGoal,
                    onBack: { assessmentFlowStep = nil },
                    onSkip: { assessmentFlowStep = nil },
                    onComplete: { assessmentFlowStep = .completed }
                )

            case .completed:
                AssessmentCompletedView(
                    onGoHome: {
                        assessmentFlowStep = nil
                        onGoHome()
                    }
                )
            }
        }
    }

    // MARK: - Sheet Header

    private var sheetHeader: some View {
        HStack {
            Color.clear
                .frame(width: 36, height: 36)

            Spacer()

            Text("Next Step")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .frame(width: 44, height: 44)
                    .background(Color.appBackground.opacity(0.95))
                    .clipShape(Circle())
            }
            .accessibilityLabel("Close")
        }
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.xs)
        .padding(.bottom, AppSpacing.sm)
        .background {
            VStack(spacing: 0) {
                Color.appSecondaryBackground

                LinearGradient(
                    colors: [
                        Color.appSecondaryBackground,
                        Color.appSecondaryBackground.opacity(0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 18)
            }
            .ignoresSafeArea()
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: AppSpacing.md) {
            Image("Assessment")
                .resizable()
                .scaledToFit()
                .frame(width: 128, height: 128)
                .accessibilityHidden(true)

            VStack(spacing: AppSpacing.xs) {
                Text(viewModel.nextStep.title)
                    .font(AppTypography.title2.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.center)

                Text("Check your PM skills and get your next roadmap.")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.sm)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Overview

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Assessment Overview")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)

            HStack(spacing: AppSpacing.sm) {
                overviewItem(
                    systemImage: "list.bullet",
                    title: "\(viewModel.nextStep.questionCount)",
                    subtitle: "Questions",
                    color: .appPrimary
                )

                overviewItem(
                    systemImage: "clock",
                    title: "\(viewModel.nextStep.estimatedMinutes)",
                    subtitle: "Minutes",
                    color: .appPrimary
                )

                overviewItem(
                    systemImage: "bolt.fill",
                    title: "+\(viewModel.nextStep.readinessDeltaPercent)%",
                    subtitle: "Readiness",
                    color: .appSuccess
                )
            }
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(cornerRadius: AppRadius.xl)
    }

    private func overviewItem(
        systemImage: String,
        title: String,
        subtitle: String,
        color: Color
    ) -> some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: systemImage)
                .font(AppTypography.headline)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background {
                    Circle()
                        .fill(color.opacity(0.12))
                }

            Text(title)
                .font(AppTypography.headline.bold())
                .foregroundStyle(Color.appTextPrimary)

            Text(subtitle)
                .font(AppTypography.caption)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }

    // MARK: - Topics

    private var topicsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            Text("Topics Covered")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)

            VStack(spacing: 0) {
                ForEach(viewModel.nextStep.topics, id: \.self) { topic in
                    HStack(spacing: AppSpacing.sm) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 7, weight: .semibold))
                            .foregroundStyle(Color.appPrimary)

                        Text(topic)
                            .font(AppTypography.subheadline)
                            .foregroundStyle(Color.appTextPrimary)

                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, AppSpacing.sm)

                    if topic != viewModel.nextStep.topics.last {
                        Divider()
                            .padding(.leading, 22)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.cardPadding)
            .padding(.vertical, AppSpacing.xs)
            .cardBackground(cornerRadius: AppRadius.xl)
        }
    }

    // MARK: - Bottom Button

    private var bottomButton: some View {
        AppButton(
            title: "Start Assessment",
            action: { assessmentFlowStep = .questions }
        )
        .padding(.horizontal, AppSpacing.screenHorizontal)
        .padding(.top, AppSpacing.sm)
        .padding(.bottom, AppSpacing.md)
        .background {
            Color.appSecondaryBackground
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NextStepDetailView()
}
