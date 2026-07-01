//
//  CareerReadinessCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

<<<<<<< HEAD
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
=======
struct CareerReadinessCard: View {

    let progress: Double
    let monthlyDeltaPercent: Int
    let action: () -> Void

    private var progressPercent: Int {
        Int((progress * 100).rounded())
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text("Career Readiness")
                            .font(AppTypography.title3.bold())
                            .foregroundStyle(Color.appTextPrimary)

                        Text(readinessStatus)
                            .font(AppTypography.subheadline)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(1)
                    }

                    TrendBadge(
                        text: "+\(monthlyDeltaPercent)% this month",
                        systemImage: "arrow.up.right",
                        color: .appSuccess
                    )
                }

                Spacer(minLength: AppSpacing.md)

                ZStack {
                    ReadinessRingView(
                        progress: progress,
                        lineWidth: 11,
                        size: 104
                    )

                    VStack(spacing: 0) {
                        Text("\(progressPercent)%")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color.appTextPrimary)
                            .monospacedDigit()
                    }
                }
                .accessibilityHidden(true)
            }
            .padding(AppSpacing.lg)
            .frame(maxWidth: .infinity, minHeight: 140, alignment: .leading)
        }
        .buttonStyle(.plain)
        .cardBackground(cornerRadius: AppRadius.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Career Readiness, \(progressPercent) percent, \(readinessStatus), up \(monthlyDeltaPercent) percent this month"
        )
        .accessibilityHint("Opens career readiness details")
    }

    private var readinessStatus: String {
        switch progressPercent {
        case 75...100:
            return "Ready for Hire"
        case 60..<75:
            return "Almost Ready"
        case 40..<60:
            return "Keep Improving"
        default:
            return "Needs Focus"
        }
    }
}

#Preview {
    CareerReadinessCard(
        progress: 0.75,
        monthlyDeltaPercent: 5,
        action: {}
    )
    .padding()
    .background(Color.appSecondaryBackground)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
}
