//
//  RoadmapView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct RoadmapView: View {

    @State private var viewModel = RoadmapViewModel()
    @State private var selectedMilestone: RoadmapMilestone?
    @State private var showProfile = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    headerSection
                    stageProgressCard
                    recommendedNextStepCard
                    roadmapSection
                    completionCard
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.top, AppSpacing.lg)
                .padding(.bottom, AppSpacing.xxxl)
            }
            .background(Color.appGroupedBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedMilestone) { milestone in
                RoadmapDetailView(milestone: milestone, stages: viewModel.stages)
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text("\(viewModel.careerGoal) Roadmap")
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(2)

                Text("Your personalized growth path")
                    .font(AppTypography.footnote)
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer()

            Button {
                showProfile = true
            } label: {
                Image("ProfileAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.appBackground, lineWidth: 2)
                    }
            }
            .accessibilityLabel("Profile")
            .accessibilityHint("Opens your profile")
        }
    }

    // MARK: - Current Stage

    private var stageProgressCard: some View {
        HStack(spacing: AppSpacing.md) {
            iconBox(
                systemName: "person.badge.key.fill",
                color: Color.appPrimary
            )

            VStack(alignment: .leading, spacing: 2) {
                Text("Current Stage")
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)

                Text(viewModel.currentStage)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appPrimary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(viewModel.progressText)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appPrimary)

                Text("Completed")
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .padding(AppSpacing.cardPadding)
        .cardBackground()
        .accessibilityElement(children: .combine)
    }

    // MARK: - Recommended Next Step

    private var recommendedNextStepCard: some View {
        Button {
            if let nextMilestone = viewModel.nextMilestone {
                selectedMilestone = nextMilestone
            }
        } label: {
            HStack(spacing: AppSpacing.md) {

                Image(systemName: "sparkles")
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 48, height: 48)
                    .background {
                        RoundedRectangle(
                            cornerRadius: AppRadius.md,
                            style: .continuous
                        )
                        .fill(Color.appPrimary.opacity(0.12))
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Recommended Next Step")
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.appPrimary)

                    Text(viewModel.nextMilestone?.title ?? "All milestones completed")
                        .font(AppTypography.headline.bold())
                        .foregroundStyle(Color.appTextPrimary)

                    if let nextMilestone = viewModel.nextMilestone {
                        Text("\(nextMilestone.estimatedMinutes) min estimated")
                            .font(AppTypography.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }

                Spacer()

                if viewModel.nextMilestone != nil {
                    Image(systemName: "arrow.right")
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appPrimary)
                }
            }
            .padding(AppSpacing.cardPadding)
            .background {
                RoundedRectangle(
                    cornerRadius: AppRadius.lg,
                    style: .continuous
                )
                .fill(Color.appPrimary.opacity(0.08))
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Roadmap Progress

    private var roadmapSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Roadmap Progress")
                .font(AppTypography.subheadline.bold())
                .foregroundStyle(Color.appTextSecondary)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                ForEach(Array(viewModel.stages.enumerated()), id: \.element.id) { offset, stage in
                    stageGroup(stage, index: offset + 1)
                }
            }
        }
    }

    private func stageGroup(_ stage: RoadmapStage, index: Int) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            RoadmapStageHeader(index: index, stage: stage)

            VStack(spacing: 0) {
                ForEach(stage.milestones) { milestone in
                    RoadmapMilestoneRow(milestone: milestone) {
                        selectedMilestone = milestone
                    }

                    if milestone.id != stage.milestones.last?.id {
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
            .cardBackground()
        }
    }

    // MARK: - Completion

    private var completionCard: some View {
        TrophyCompletionCard(
            title: "Complete all milestones",
            subtitle: "Finish your roadmap and become a stronger \(viewModel.careerGoal).",
            isLocked: !viewModel.stages.allSatisfy { $0.status == .completed }
        )
    }

    // MARK: - Reusable Icon

    private func iconBox(systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(AppTypography.title3.bold())
            .foregroundStyle(color)
            .frame(width: 48, height: 48)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                    .fill(color.opacity(0.12))
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    RoadmapView()
}
