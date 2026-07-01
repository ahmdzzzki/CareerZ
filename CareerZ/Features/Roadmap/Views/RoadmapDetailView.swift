//
//  RoadmapDetailView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct RoadmapDetailView: View {

    let milestone: RoadmapMilestone
    let stages: [RoadmapStage]

    private var detail: RoadmapMilestoneDetail? {
        milestone.detail
    }

    private var completedLessonsCount: Int {
        detail?.lessons.filter { $0.status == .completed }.count ?? 0
    }

    private var totalLessonsCount: Int {
        detail?.lessons.count ?? 0
    }

    private var progressValue: Double {
        guard totalLessonsCount > 0 else { return 0 }
        return Double(completedLessonsCount) / Double(totalLessonsCount)
    }

    private var positionBadgeText: String? {
        let allMilestones = stages.flatMap(\.milestones)

        guard let overallIndex = allMilestones.firstIndex(where: { $0.id == milestone.id }),
              let stage = stages.first(where: { $0.milestones.contains(where: { $0.id == milestone.id }) }) else {
            return nil
        }

        return "\(overallIndex + 1) of \(allMilestones.count) • \(stage.title)"
    }

    init(
        milestone: RoadmapMilestone,
        stages: [RoadmapStage] = RoadmapStage.sample
    ) {
        self.milestone = milestone
        self.stages = stages
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                headerSection

                if let detail {
                    infoCards(detail)
                    progressSection
                    lessonsSection(detail)
                    learningSection(detail)
                    completionCard
                } else {
                    unavailableState
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xxxl)
        }
        .background(Color.appSecondaryBackground)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            if let positionBadgeText {
                Text(positionBadgeText.uppercased())
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appPrimary)
                    .padding(.horizontal, AppSpacing.sm)
                    .padding(.vertical, AppSpacing.xxs)
                    .background {
                        Capsule()
                            .fill(Color.appPrimary.opacity(0.12))
                    }
            }

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(milestone.title)
                    .font(AppTypography.title2.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(detail?.description ?? "This milestone detail is not available yet.")
                    .font(AppTypography.footnote)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(milestone.title), \(milestone.status.accessibilityDescription)")
    }

    // MARK: - Info Cards

    private func infoCards(_ detail: RoadmapMilestoneDetail) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: AppSpacing.sm),
                GridItem(.flexible(), spacing: AppSpacing.sm)
            ],
            spacing: AppSpacing.sm
        ) {
            infoCard(
                icon: "clock",
                title: "Estimated Time",
                value: detail.estimatedTimeLabel,
                color: Color.appInfo
            )

            infoCard(
                icon: "chart.bar",
                title: "Impact",
                value: detail.impact,
                color: Color.appPrimary
            )
        }
    }

    private func infoCard(
        icon: String,
        title: String,
        value: String,
        color: Color
    ) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: icon)
                .font(AppTypography.subheadline.bold())
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background {
                    Circle()
                        .fill(color.opacity(0.12))
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(value)
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, minHeight: 78, alignment: .leading)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value)")
    }

    // MARK: - Progress

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            HStack {
                Text("Your Progress")
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Spacer()

                Text("\(completedLessonsCount) of \(totalLessonsCount) completed")
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appPrimary)
            }

            ProgressView(value: progressValue)
                .tint(Color.appPrimary)
                .accessibilityLabel("Lesson progress")
                .accessibilityValue("\(completedLessonsCount) of \(totalLessonsCount) completed")
        }
    }

    // MARK: - Lessons

    private func lessonsSection(_ detail: RoadmapMilestoneDetail) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Lessons")
                .font(AppTypography.subheadline.bold())
                .foregroundStyle(Color.appTextPrimary)

            VStack(spacing: 0) {
                ForEach(Array(detail.lessons.enumerated()), id: \.element.id) { index, lesson in
                    RoadmapLessonRow(index: index + 1, lesson: lesson) {
                        // TODO: Navigate to lesson detail screen.
                    }

                    if lesson.id != detail.lessons.last?.id {
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

    // MARK: - Learning

    private func learningSection(_ detail: RoadmapMilestoneDetail) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("What you'll learn")
                .font(AppTypography.subheadline.bold())
                .foregroundStyle(Color.appTextPrimary)

            VStack(alignment: .leading, spacing: AppSpacing.md) {
                ForEach(detail.whatYoullLearn, id: \.self) { item in
                    HStack(alignment: .top, spacing: AppSpacing.sm) {
                        Image(systemName: "checkmark.seal")
                            .font(AppTypography.subheadline)
                            .foregroundStyle(Color.appPrimary)
                            .frame(width: 24)
                            .accessibilityHidden(true)

                        Text(item)
                            .font(AppTypography.subheadline)
                            .foregroundStyle(Color.appTextSecondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Spacer(minLength: 0)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppSpacing.cardPadding)
            .cardBackground()
        }
    }

    // MARK: - Completion

    private var completionCard: some View {
        TrophyCompletionCard(
            title: "Complete all lessons",
            subtitle: "Unlock the next step and move closer to your goal",
            isLocked: completedLessonsCount < totalLessonsCount
        )
    }

    // MARK: - Empty State

    private var unavailableState: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "lock.fill")
                .font(AppTypography.title2)
                .foregroundStyle(Color.appTextTertiary)
                .frame(width: 56, height: 56)
                .background {
                    Circle()
                        .fill(Color.appTextTertiary.opacity(0.10))
                }
                .accessibilityHidden(true)

            Text("Detail Not Available Yet")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)

            Text("Complete earlier milestones to unlock this lesson detail.")
                .font(AppTypography.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(AppSpacing.xl)
        .cardBackground()
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        RoadmapDetailView(
            milestone: RoadmapStage.sample[1].milestones[0]
        )
    }
}
