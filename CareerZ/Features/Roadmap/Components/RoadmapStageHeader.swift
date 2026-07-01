//
//  RoadmapStageHeader.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Header row for a stage group in the roadmap overview, e.g.
/// "1. Foundation" with a status dot/check on the leading edge.
struct RoadmapStageHeader: View {

    let index: Int
    let stage: RoadmapStage

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: stage.status.systemImage)
                .font(AppTypography.subheadline)
                .foregroundStyle(stage.status.color)

            Text("\(index). \(stage.title)")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Stage \(index), \(stage.title), \(stage.status.accessibilityDescription)")
    }
}

#Preview {
    VStack(alignment: .leading, spacing: AppSpacing.md) {
        RoadmapStageHeader(index: 1, stage: RoadmapStage.sample[0])
        RoadmapStageHeader(index: 2, stage: RoadmapStage.sample[1])
        RoadmapStageHeader(index: 3, stage: RoadmapStage.sample[2])
    }
    .padding()
    .background(Color.appGroupedBackground)
}
