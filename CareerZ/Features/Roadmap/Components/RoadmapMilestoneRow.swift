//
//  RoadmapMilestoneRow.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// One milestone row within a stage group, e.g. "User Research"
/// under "Intermediate". Always tappable — even locked milestones
/// can be previewed, per product decision.
struct RoadmapMilestoneRow: View {

    let milestone: RoadmapMilestone
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: milestone.status.systemImage)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(milestone.status.color)
                    .frame(width: 20)

                Text(milestone.title)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextPrimary)

                Spacer(minLength: AppSpacing.xs)

                Image(systemName: "chevron.right")
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextTertiary)
            }
            .padding(.vertical, AppSpacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(milestone.title), \(milestone.status.accessibilityDescription)")
        .accessibilityHint("Opens milestone details")
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(RoadmapStage.sample[1].milestones) { milestone in
            RoadmapMilestoneRow(milestone: milestone, action: {})
            Divider()
        }
    }
    .padding()
    .cardBackground()
    .padding()
    .background(Color.appGroupedBackground)
}
