//
//  FocusAreasDetailView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct FocusAreaDetailView: View {

    @State private var viewModel: FocusAreaDetailViewModel
    @Environment(\.dismiss) private var dismiss

    init(focusArea: FocusArea) {
        _viewModel = State(initialValue: FocusAreaDetailViewModel(focusArea: focusArea))
    }

    private var area: FocusArea { viewModel.focusArea }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.sectionSpacing) {
                headerCard

                if let detail = area.detail {
                    whatThisMeansSection(detail.whatThisMeans)
                    measuredBySection(detail.measuredBy)
                    ExpandableSection(
                        title: "Why does \(area.title) matter?",
                        detail: detail.whyItMatters
                    )
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.vertical, AppSpacing.screenVertical)
        }
        .background(Color.appBackground)
        .navigationTitle(area.title)
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

    // MARK: - Header

    private var headerCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: area.systemImage)
                .font(AppTypography.title)
                .foregroundStyle(area.status.color)
                .frame(width: 64, height: 64)
                .background {
                    RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                        .fill(area.status.color.opacity(0.12))
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text("\(area.percent)%")
                    .font(AppTypography.largeTitle.bold())
                    .foregroundStyle(area.status.color)
                    .monospacedDigit()

                Text(area.status.label)
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextPrimary)

                if let whatThisMeans = area.detail?.whatThisMeans {
                    Text(whatThisMeans)
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.cardPadding)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(area.percent) percent, \(area.status.label)")
    }

    // MARK: - What this means

    private func whatThisMeansSection(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("WHAT THIS MEANS")
                .font(AppTypography.caption.bold())
                .foregroundStyle(Color.appTextSecondary)
                .accessibilityAddTraits(.isHeader)

            Text(text)
                .font(AppTypography.subheadline)
                .foregroundStyle(Color.appTextPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Measured by

    private func measuredBySection(_ metrics: [FocusAreaMetric]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            Text("MEASURED BY")
                .font(AppTypography.caption.bold())
                .foregroundStyle(Color.appTextSecondary)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: 0) {
                ForEach(metrics) { metric in
                    ExpandableInfoRow(
                        title: metric.title,
                        summary: metric.summary,
                        detail: metric.detail,
                        isExpanded: viewModel.isExpanded(metric),
                        onToggle: { viewModel.toggleExpanded(metric) }
                    )

                    if metric.id != metrics.last?.id {
                        Divider()
                    }
                }
            }
            .padding(.horizontal, AppSpacing.cardPadding)
            .cardBackground()
        }
    }
}

#Preview {
    NavigationStack {
        FocusAreaDetailView(focusArea: FocusArea.sample[1]) // Networking
    }
}
