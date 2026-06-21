//
//  ExpandableInfoRow.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Generic accordion row: title + optional trailing badge, expands
/// in place on tap to reveal detail text. No navigation involved.
///
/// Used for:
/// - "How your score is calculated" (Career Readiness) — title +
///   percent badge + icon.
/// - "Measured by" (Focus Area detail) — title + one-line summary,
///   no icon/badge.
struct ExpandableInfoRow: View {

    let title: String
    var systemImage: String? = nil
    /// Trailing text shown collapsed and expanded, e.g. "80%". Pass
    /// nil to omit (Measured by rows don't have one).
    var trailingBadgeText: String? = nil
    var trailingBadgeColor: Color = .appTextPrimary
    /// One-line text shown under the title even when collapsed, e.g.
    /// "The quality and quantity of your connections." Pass nil to
    /// omit (Score breakdown rows don't have one).
    var summary: String? = nil
    /// Longer text revealed only when expanded.
    let detail: String

    let isExpanded: Bool
    let onToggle: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                    onToggle()
                }
            } label: {
                HStack(alignment: .top, spacing: AppSpacing.sm) {
                    if let systemImage {
                        iconBadge(systemImage)
                    }

                    VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                        Text(title)
                            .font(AppTypography.subheadline.bold())
                            .foregroundStyle(Color.appTextPrimary)

                        if let summary {
                            Text(summary)
                                .font(AppTypography.caption)
                                .foregroundStyle(Color.appTextSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    Spacer(minLength: AppSpacing.xs)

                    if let trailingBadgeText {
                        Text(trailingBadgeText)
                            .font(AppTypography.subheadline.bold())
                            .foregroundStyle(trailingBadgeColor)
                            .monospacedDigit()
                    }

                    Image(systemName: "chevron.right")
                        .font(AppTypography.caption.bold())
                        .foregroundStyle(Color.appTextSecondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.vertical, AppSpacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabelText)
            .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
            .accessibilityAddTraits(.isButton)

            if isExpanded {
                Text(detail)
                    .font(AppTypography.footnote)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, AppSpacing.sm)
                    .padding(.leading, leadingInset)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var leadingInset: CGFloat {
        systemImage != nil ? 32 + AppSpacing.sm : 0
    }

    private var accessibilityLabelText: String {
        var parts = [title]
        if let trailingBadgeText { parts.append(trailingBadgeText) }
        if let summary { parts.append(summary) }
        return parts.joined(separator: ", ")
    }

    private func iconBadge(_ systemImage: String) -> some View {
        Image(systemName: systemImage)
            .font(AppTypography.caption)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 32, height: 32)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                    .fill(Color.appPrimary.opacity(0.12))
            }
            .accessibilityHidden(true)
    }
}

#Preview {
    @Previewable @State var expandedID: String? = "assessment-results"
    VStack(spacing: 0) {
        ExpandableInfoRow(
            title: "Assessment Results",
            systemImage: "doc.text.fill",
            trailingBadgeText: "80%",
            trailingBadgeColor: .appSuccess,
            detail: "Based on your latest PM Assessment, covering product strategy, execution, and stakeholder management questions.",
            isExpanded: expandedID == "assessment-results",
            onToggle: { expandedID = expandedID == "assessment-results" ? nil : "assessment-results" }
        )
        Divider()
        ExpandableInfoRow(
            title: "Professional Connections",
            summary: "The quality and quantity of your connections.",
            detail: "Looks at how many relevant industry contacts you've added and how active those connections are.",
            isExpanded: expandedID == "connections",
            onToggle: { expandedID = expandedID == "connections" ? nil : "connections" }
        )
    }
    .padding()
    .background(Color.appGroupedBackground)
}
