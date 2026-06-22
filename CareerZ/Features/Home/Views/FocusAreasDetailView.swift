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
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                headerCard

                if let detail = area.detail {
                    insightCard(detail.whatThisMeans)
                    measuredBySection(detail.measuredBy)
                    compactInfoCard(detail.whyItMatters)
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.screenVertical)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appSecondaryBackground)
        .navigationTitle(area.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(Color.appTextPrimary)
        }
        .accessibilityLabel("Back")
    }

    // MARK: - Header

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: area.systemImage)
                    .font(AppTypography.title)
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 64, height: 64)
                    .background {
                        RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                            .fill(Color.appPrimary.opacity(0.12))
                    }
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(area.title)
                        .font(AppTypography.headline)
                        .foregroundStyle(Color.appTextPrimary)

                    Text(area.status.label)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                }

                Spacer(minLength: 0)

                Text("\(area.percent)%")
                    .font(AppTypography.largeTitle.bold())
                    .foregroundStyle(area.status.color)
                    .monospacedDigit()
            }

            ProgressView(value: Double(area.percent), total: 100)
                .tint(area.status.color)
                .accessibilityLabel("\(area.title) progress")
                .accessibilityValue("\(area.percent) percent")
        }
        .padding(AppSpacing.cardPadding)
        .cardBackground(cornerRadius: AppRadius.xl)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(area.title), \(area.percent) percent, \(area.status.label)")
    }

    // MARK: - Insight

    private func insightCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label("Insight", systemImage: "sparkles")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appPrimary)

            Text(shortInsight(from: text))
                .font(AppTypography.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(cornerRadius: AppRadius.xl)
    }

    // MARK: - Measured By

    private func measuredBySection(_ metrics: [FocusAreaMetric]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            Text("Measured By")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appTextPrimary)

            VStack(spacing: 0) {
                ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                    metricRow(metric, index: index)

                    if metric.id != metrics.last?.id {
                        Divider()
                            .padding(.leading, 52)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.cardPadding)
            .padding(.vertical, AppSpacing.xs)
            .cardBackground(cornerRadius: AppRadius.xl)
        }
    }

    private func metricRow(_ metric: FocusAreaMetric, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.22)) {
                viewModel.toggleExpanded(metric)
            }
        } label: {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    metricIcon(index: index, title: metric.title)

                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text(metric.title)
                            .font(AppTypography.subheadline.bold())
                            .foregroundStyle(Color.appTextPrimary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(metric.summary)
                            .font(AppTypography.caption)
                            .foregroundStyle(Color.appTextSecondary)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    Spacer(minLength: AppSpacing.xs)

                    Image(systemName: viewModel.isExpanded(metric) ? "chevron.up" : "chevron.down")
                        .font(AppTypography.caption.bold())
                        .foregroundStyle(Color.appTextTertiary)
                        .padding(.top, 4)
                }

                if viewModel.isExpanded(metric) {
                    metricVisualDetail(metric, index: index)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.vertical, AppSpacing.sm)
        }
        .buttonStyle(.plain)
    }

    private func metricVisualDetail(_ metric: FocusAreaMetric, index: Int) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                visualPill(
                    title: "Score",
                    value: "\(metricProgress(index: index))%",
                    systemImage: "gauge.with.dots.needle.bottom.50percent"
                )

                visualPill(
                    title: "Priority",
                    value: priorityValue(index: index),
                    systemImage: "flag"
                )
            }

            ProgressView(value: Double(metricProgress(index: index)), total: 100)
                .tint(Color.appPrimary)

            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "arrow.up.right.circle.fill")
                    .font(AppTypography.caption)

                Text(actionHint(for: metric.title))
                    .font(AppTypography.caption.bold())
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .foregroundStyle(Color.appPrimary)
        }
        .padding(AppSpacing.sm)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
                .fill(Color.appPrimary.opacity(0.06))
        }
        .padding(.leading, 52)
    }

    private func visualPill(
        title: String,
        value: String,
        systemImage: String
    ) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: systemImage)
                .font(AppTypography.caption)
                .foregroundStyle(Color.appPrimary)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(Color.appTextSecondary)

                Text(value)
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.xs)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                .fill(Color.appBackground)
        }
    }

    private func metricIcon(index: Int, title: String) -> some View {
        Image(systemName: metricIconName(index: index, title: title))
            .font(AppTypography.subheadline)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 36, height: 36)
            .background {
                Circle()
                    .fill(Color.appPrimary.opacity(0.10))
            }
    }

    // MARK: - Why It Matters

    private func compactInfoCard(_ text: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Label("Why it matters", systemImage: "lightbulb")
                .font(AppTypography.headline)
                .foregroundStyle(Color.appPrimary)

            Text(shortInsight(from: text))
                .font(AppTypography.subheadline)
                .foregroundStyle(Color.appTextSecondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground(cornerRadius: AppRadius.xl)
    }

    // MARK: - Helpers

    private func shortInsight(from text: String) -> String {
        let sentences = text.split(separator: ".")
        return sentences.first.map { String($0) + "." } ?? text
    }

    private func metricProgress(index: Int) -> Int {
        let values = [68, 52, 45, 74, 60]
        return values[index % values.count]
    }

    private func priorityValue(index: Int) -> String {
        let values = ["High", "Medium", "High", "Low", "Medium"]
        return values[index % values.count]
    }

    private func metricIconName(index: Int, title: String) -> String {
        let title = title.lowercased()

        if title.contains("connection") { return "person.crop.circle.badge.plus" }
        if title.contains("activit") { return "calendar.badge.clock" }
        if title.contains("industry") { return "globe.asia.australia" }
        if title.contains("tool") { return "wrench.adjustable" }
        if title.contains("concept") { return "brain.head.profile" }
        if title.contains("practice") { return "hammer" }
        if title.contains("resume") { return "doc.text" }
        if title.contains("portfolio") { return "folder" }
        if title.contains("presence") { return "person.text.rectangle" }
        if title.contains("initiative") { return "bolt" }
        if title.contains("influence") { return "person.3" }
        if title.contains("decision") { return "checkmark.seal" }
        if title.contains("adaptability") { return "arrow.triangle.2.circlepath" }
        if title.contains("learning") { return "book" }
        if title.contains("curiosity") { return "sparkles" }

        let fallbackIcons = ["chart.bar", "target", "scope", "flag", "star"]
        return fallbackIcons[index % fallbackIcons.count]
    }

    private func actionHint(for title: String) -> String {
        let title = title.lowercased()

        if title.contains("connection") { return "Add 2 new connections this week." }
        if title.contains("activit") { return "Join one community or career event." }
        if title.contains("industry") { return "Share one insight in your industry." }
        if title.contains("tool") { return "Practice one role-relevant tool." }
        if title.contains("concept") { return "Review one core concept." }
        if title.contains("practice") { return "Build one small project." }

        return "Take one focused action this week."
    }
}

#Preview {
    NavigationStack {
        FocusAreaDetailView(focusArea: FocusArea.sample[1])
    }
}
