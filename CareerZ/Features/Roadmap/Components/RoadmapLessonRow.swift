//
//  RoadmapLessonRow.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// One lesson row in RoadmapDetailView's "Lessons" list. The whole
/// row is tappable to view lesson content; an in-progress lesson
/// additionally shows a "Continue" affordance.
struct RoadmapLessonRow: View {

    let index: Int
    let lesson: RoadmapLesson
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: lesson.status.systemImage)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(lesson.status.color)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(index). \(lesson.title)")
                        .font(AppTypography.subheadline)
                        .foregroundStyle(Color.appTextPrimary)

                    Text("\(lesson.durationMinutes) min")
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.appTextSecondary)
                }

                Spacer(minLength: AppSpacing.xs)

                if lesson.status == .inProgress {
                    continueBadge
                }
            }
            .padding(.vertical, AppSpacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(lesson.status == .locked)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(index). \(lesson.title), \(lesson.durationMinutes) minutes, \(lesson.status.accessibilityDescription)")
        .accessibilityHint(lesson.status == .locked ? "" : "Opens lesson content")
    }

    private var continueBadge: some View {
        Text("Continue")
            .font(AppTypography.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs)
            .background {
                Capsule().fill(Color.appPrimary)
            }
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(Array((RoadmapStage.sample[1].milestones.first?.detail?.lessons ?? []).enumerated()), id: \.element.id) { index, lesson in
            RoadmapLessonRow(index: index + 1, lesson: lesson, action: {})
            Divider()
        }
    }
    .padding()
    .cardBackground()
    .padding()
    .background(Color.appBackground)
}
