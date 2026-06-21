//
//  CareerReadinessView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct CareerReadinessView: View {

    @State private var viewModel = CareerReadinessViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.sectionSpacing) {
                ringSection

                breakdownSection

                historySection
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.screenVertical)
        }
        .background(Color.appBackground)
        .navigationTitle("Career Readiness")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.appTextPrimary)
                }
                .accessibilityLabel("Back")
            }
        }
    }

    // MARK: - Ring

    private var ringSection: some View {
        VStack(spacing: AppSpacing.sm) {
            ReadinessRingView(progress: viewModel.readinessProgress, size: 160)

            TrendBadge(text: "+\(viewModel.readinessMonthlyDelta)% this month")
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppSpacing.md)
    }

    // MARK: - Breakdown

    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            Text("HOW YOUR SCORE IS CALCULATED")
                .font(AppTypography.caption.bold())
                .foregroundStyle(Color.appTextSecondary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(viewModel.scoreComponents) { component in
                    ExpandableInfoRow(
                        title: component.title,
                        systemImage: component.systemImage,
                        trailingBadgeText: "\(component.percent)%",
                        trailingBadgeColor: ReadinessStatus(percent: component.percent).color,
                        detail: component.detail,
                        isExpanded: viewModel.isExpanded(component),
                        onToggle: { viewModel.toggleExpanded(component) }
                    )

                    if component.id != viewModel.scoreComponents.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.horizontal, AppSpacing.cardPadding)
            .cardBackground()
        }
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            HStack {
                Text("YOUR READINESS OVER TIME")
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextSecondary)
                    .accessibilityAddTraits(.isHeader)

                Spacer()

                TrendBadge(text: "+\(viewModel.historyDeltaVsLastMonth)% vs last month")
            }

            Text("See how you've improved over the past months.")
                .font(AppTypography.footnote)
                .foregroundStyle(Color.appTextSecondary)

            ReadinessChart(points: viewModel.history)
                .padding(AppSpacing.cardPadding)
                .cardBackground()
        }
    }
}

#Preview {
    NavigationStack {
        CareerReadinessView()
    }
}
