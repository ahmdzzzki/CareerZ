//
//  NextStepCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct NextStepCard: View {

    let nextStep: NextStep
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack(alignment: .center, spacing: AppSpacing.md) {
                    iconImage

                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text("PM Assessment")
                            .font(AppTypography.headline)
                            .foregroundStyle(Color.appTextPrimary)

                        Text("Check your PM skills and get your next roadmap.")
                            .font(AppTypography.subheadline)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)

                        TrendBadge(
                            text: "+\(nextStep.readinessDeltaPercent)% Readiness",
                            systemImage: "bolt.fill",
                            color: .appSuccess
                        )
                    }

                    Spacer(minLength: 0)
                }

                Divider()
                    .overlay(Color.appSeparator.opacity(0.35))

                metaRow
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .cardBackground(cornerRadius: AppRadius.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "PM Assessment. Check your product management skills and get your next roadmap. "
            + "Plus \(nextStep.readinessDeltaPercent) percent readiness. "
            + "\(nextStep.estimatedMinutes) minutes, \(nextStep.questionCount) questions."
        )
        .accessibilityHint("Opens assessment")
    }

    private var iconImage: some View {
        Image("Assessment")
            .resizable()
            .scaledToFit()
            .frame(width: 82, height: 82)
            .accessibilityHidden(true)
    }

    private var metaRow: some View {
        HStack(spacing: AppSpacing.lg) {
            metaItem(
                systemImage: "clock",
                text: "\(nextStep.estimatedMinutes) min"
            )

            metaItem(
                systemImage: "list.bullet",
                text: "\(nextStep.questionCount) Questions"
            )

            Spacer(minLength: 0)
        }
        .foregroundStyle(Color.appTextSecondary)
        .accessibilityHidden(true)
    }

    private func metaItem(systemImage: String, text: String) -> some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: systemImage)
                .font(AppTypography.caption)

            Text(text)
                .font(AppTypography.caption)
                .lineLimit(1)
        }
    }
}

#Preview {
    NextStepCard(nextStep: .sample, action: {})
        .padding()
        .background(Color.appSecondaryBackground)
}
