//
//  NextStepCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

<<<<<<< HEAD
/// CTA card on Home prompting the user to complete their next
/// recommended step (e.g. an assessment). Tapping navigates to
/// the Next Step Detail screen.
=======
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
struct NextStepCard: View {

    let nextStep: NextStep
    let action: () -> Void

    var body: some View {
        Button(action: action) {
<<<<<<< HEAD
            HStack(alignment: .top, spacing: AppSpacing.sm) {
                iconBadge

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(nextStep.title)
                        .font(AppTypography.headline)
                        .foregroundStyle(Color.appTextPrimary)

                    Text(nextStep.description)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)

                    TrendBadge(
                        text: "+\(nextStep.readinessDeltaPercent)% Readiness",
                        systemImage: "bolt",
                        color: .appSuccess
                    )
                    .padding(.top, AppSpacing.xxs)

                    metaRow
                        .padding(.top, AppSpacing.xs)
                }

                Spacer(minLength: 0)
=======
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
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
<<<<<<< HEAD
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(nextStep.title). \(nextStep.description). "
            + "Plus \(nextStep.readinessDeltaPercent) percent readiness. "
            + "Estimated \(nextStep.estimatedMinutes) minutes, \(nextStep.questionCount) questions."
        )
        .accessibilityHint("Opens next step details")
    }

    private var iconBadge: some View {
        Image(systemName: nextStep.systemImage)
            .font(AppTypography.title3)
            .foregroundStyle(Color.appInfo)
            .frame(width: 44, height: 44)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                    .fill(Color.appInfo.opacity(0.12))
            }
=======
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
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            .accessibilityHidden(true)
    }

    private var metaRow: some View {
<<<<<<< HEAD
        HStack(spacing: AppSpacing.sm) {
            metaItem(systemImage: "clock", text: "Estimated \(nextStep.estimatedMinutes) min")
            metaItem(systemImage: "list.bullet", text: "\(nextStep.questionCount) Questions")
        }
        .accessibilityHidden(true) // already covered by combined label above
=======
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
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    }

    private func metaItem(systemImage: String, text: String) -> some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: systemImage)
<<<<<<< HEAD
                .font(AppTypography.caption2)
            Text(text)
                .font(AppTypography.caption)
        }
        .foregroundStyle(Color.appTextSecondary)
=======
                .font(AppTypography.caption)

            Text(text)
                .font(AppTypography.caption)
                .lineLimit(1)
        }
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    }
}

#Preview {
    NextStepCard(nextStep: .sample, action: {})
        .padding()
<<<<<<< HEAD
        .background(Color.appBackground)
=======
        .background(Color.appSecondaryBackground)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
}
