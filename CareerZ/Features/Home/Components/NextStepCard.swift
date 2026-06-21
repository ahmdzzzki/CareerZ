//
//  NextStepCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// CTA card on Home prompting the user to complete their next
/// recommended step (e.g. an assessment). Tapping navigates to
/// the Next Step Detail screen.
struct NextStepCard: View {

    let nextStep: NextStep
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
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
            .accessibilityHidden(true)
    }

    private var metaRow: some View {
        HStack(spacing: AppSpacing.sm) {
            metaItem(systemImage: "clock", text: "Estimated \(nextStep.estimatedMinutes) min")
            metaItem(systemImage: "list.bullet", text: "\(nextStep.questionCount) Questions")
        }
        .accessibilityHidden(true) // already covered by combined label above
    }

    private func metaItem(systemImage: String, text: String) -> some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: systemImage)
                .font(AppTypography.caption2)
            Text(text)
                .font(AppTypography.caption)
        }
        .foregroundStyle(Color.appTextSecondary)
    }
}

#Preview {
    NextStepCard(nextStep: .sample, action: {})
        .padding()
        .background(Color.appBackground)
}
