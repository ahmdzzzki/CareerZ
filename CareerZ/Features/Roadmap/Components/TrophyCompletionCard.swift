//
//  TrophyCompletionCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Trophy card shown at the bottom of the roadmap overview ("Complete
/// all milestones") and milestone detail ("Complete all lessons").
/// Visually de-emphasized while locked (not yet achievable).
struct TrophyCompletionCard: View {

    let title: String
    let subtitle: String
    let isLocked: Bool

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "trophy")
                .font(AppTypography.title3)
                .foregroundStyle(isLocked ? Color.appTextTertiary : Color.appWarning)
                .frame(width: 44, height: 44)
                .background {
                    Circle().fill((isLocked ? Color.appTextTertiary : Color.appWarning).opacity(0.12))
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)

            if !isLocked {
                Image(systemName: "chevron.right")
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextTertiary)
            }
        }
        .padding(AppSpacing.cardPadding)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .opacity(isLocked ? 0.6 : 1)
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        TrophyCompletionCard(
            title: "Complete all milestones",
            subtitle: "Become a well-rounded Product Manager and achieve your career goal.",
            isLocked: true
        )
        TrophyCompletionCard(
            title: "Complete all lessons",
            subtitle: "Unlock the next step in your Product Manager roadmap.",
            isLocked: false
        )
    }
    .padding()
    .background(Color.appBackground)
}
