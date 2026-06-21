//
//  FocusAreaCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Compact card for a single focus area, used in Home's horizontal
/// scroll row. Tapping navigates to that area's detail screen.
struct FocusAreaCard: View {

    let focusArea: FocusArea
    let action: () -> Void

    private let cardWidth: CGFloat = 130
    /// Fixed height keeps every card in the horizontal row visually
    /// aligned regardless of whether the title wraps to 1 or 2 lines.
    private let cardHeight: CGFloat = 168

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                iconBadge

                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(focusArea.title)
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(focusArea.percent)%")
                        .font(AppTypography.headline.bold())
                        .foregroundStyle(focusArea.status.color)
                        .monospacedDigit()

                    Text(focusArea.status.label)
                        .font(AppTypography.caption2)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                progressBar
            }
            .padding(AppSpacing.sm)
            .frame(width: cardWidth, height: cardHeight, alignment: .topLeading)
        }
        .buttonStyle(.plain)
        .cardBackground(cornerRadius: AppRadius.md)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(focusArea.title), \(focusArea.percent) percent, \(focusArea.status.label)")
        .accessibilityHint("Opens \(focusArea.title) details")
    }

    private var iconBadge: some View {
        Image(systemName: focusArea.systemImage)
            .font(AppTypography.subheadline)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 32, height: 32)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                    .fill(Color.appPrimary.opacity(0.12))
            }
            .accessibilityHidden(true) // decorative, info already in label
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.appSecondaryFill)

                Capsule()
                    .fill(focusArea.status.color)
                    .frame(width: geo.size.width * CGFloat(focusArea.percent) / 100)
            }
        }
        .frame(height: 4)
        .accessibilityHidden(true) // percent already announced in label
    }
}

#Preview {
    ScrollView(.horizontal) {
        HStack(spacing: AppSpacing.sm) {
            ForEach(FocusArea.sample) { area in
                FocusAreaCard(focusArea: area, action: {})
            }
        }
        .padding()
    }
    .background(Color.appBackground)
}
