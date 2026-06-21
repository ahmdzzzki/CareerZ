//
//  CareerReadinessCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Card shown on Home, wraps ReadinessRingView with title and
/// a "+X% this month" trend badge. Tappable to push CareerReadinessView.
struct CareerReadinessCard: View {

    let progress: Double          // 0.0 - 1.0
    let monthlyDeltaPercent: Int  // e.g. 5 -> "+5% this month"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Career Readiness")
                        .font(AppTypography.title3.bold())
                        .foregroundStyle(Color.appTextPrimary)

                    Text("Ready for Hire")
                        .font(AppTypography.subheadline)
                        .foregroundStyle(Color.appTextSecondary)

                    TrendBadge(text: "+\(monthlyDeltaPercent)% this month")
                        .padding(.top, AppSpacing.xxs)
                }

                Spacer(minLength: AppSpacing.sm)

                ReadinessRingView(progress: progress, lineWidth: 12, size: 110)
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens career readiness details")
    }

}

#Preview {
    CareerReadinessCard(progress: 0.75, monthlyDeltaPercent: 5, action: {})
        .padding()
        .background(Color.appBackground)
}
