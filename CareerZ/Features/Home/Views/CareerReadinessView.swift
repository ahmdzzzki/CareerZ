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

    private var progressPercent: Int {
        Int((viewModel.readinessProgress * 100).rounded())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                heroCard
                breakdownSection
                historySection
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.screenVertical)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appGroupedBackground)
        .navigationTitle("Career Readiness")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }

    // MARK: - Back Button

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(Color.appTextPrimary)
        }
        .accessibilityLabel("Back")
    }

    // MARK: - Hero

    private var heroCard: some View {
        VStack(spacing: AppSpacing.md) {
            ReadinessRingView(
                progress: viewModel.readinessProgress,
                lineWidth: 14,
                size: 172
            )

            VStack(spacing: AppSpacing.xs) {
                Text(readinessStatus)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Text("Your career profile is progressing well.")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }

            TrendBadge(
                text: "+\(viewModel.readinessMonthlyDelta)% this month",
                systemImage: "arrow.up.right",
                color: .appSuccess
            )
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity)
        .cardBackground(cornerRadius: AppRadius.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Career readiness \(progressPercent) percent. \(readinessStatus). Up \(viewModel.readinessMonthlyDelta) percent this month."
        )
    }

    // MARK: - Breakdown

    private var breakdownSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            sectionTitle("Score Breakdown")

            VStack(spacing: AppSpacing.sm) {
                ForEach(viewModel.scoreComponents) { component in
                    scoreComponentRow(component)
                }
            }
        }
    }

    private func scoreComponentRow(_ component: ScoreComponent) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                viewModel.toggleExpanded(component)
            }
        } label: {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(spacing: AppSpacing.sm) {
                    Image(systemName: component.systemImage)
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appPrimary)
                        .frame(width: 38, height: 38)
                        .background {
                            RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                                .fill(Color.appPrimary.opacity(0.12))
                        }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(component.title)
                            .font(AppTypography.subheadline.bold())
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(1)

                        Text(componentSubtitle(for: component.percent))
                            .font(AppTypography.caption)
                            .foregroundStyle(Color.appTextSecondary)
                    }

                    Spacer(minLength: AppSpacing.xs)

                    Text("\(component.percent)%")
                        .font(AppTypography.headline.bold())
                        .foregroundStyle(ReadinessStatus(percent: component.percent).color)
                        .monospacedDigit()

                    Image(systemName: viewModel.isExpanded(component) ? "chevron.up" : "chevron.down")
                        .font(AppTypography.caption.bold())
                        .foregroundStyle(Color.appTextTertiary)
                }

                ProgressView(value: Double(component.percent), total: 100)
                    .tint(ReadinessStatus(percent: component.percent).color)

                if viewModel.isExpanded(component) {
                    Text(component.detail)
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardBackground(cornerRadius: AppRadius.lg)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }

    // MARK: - History

    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            HStack(alignment: .center) {
                sectionTitle("Readiness Over Time")

                Spacer()

                TrendBadge(
                    text: "+\(viewModel.historyDeltaVsLastMonth)% vs last month",
                    systemImage: "arrow.up.right",
                    color: .appSuccess
                )
            }

            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Your score is improving compared to last month.")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
                    .lineLimit(2)

                ReadinessChart(points: viewModel.history)
                    .frame(height: 180)
            }
            .padding(AppSpacing.cardPadding)
            .cardBackground(cornerRadius: AppRadius.xl)
        }
    }

    // MARK: - Helpers

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(AppTypography.headline)
            .foregroundStyle(Color.appTextPrimary)
            .accessibilityAddTraits(.isHeader)
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

    private func componentSubtitle(for percent: Int) -> String {
        switch percent {
        case 75...100:
            return "Strong contribution"
        case 60..<75:
            return "Good progress"
        case 40..<60:
            return "Needs attention"
        default:
            return "Needs focus"
        }
    }
}

#Preview {
    NavigationStack {
        CareerReadinessView()
    }
}
