//
//  FocusAreaGridCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Grid variant of the focus area card, used in the "Focus Areas All"
/// 2-column grid. Unlike FocusAreaCard (fixed width, horizontal
/// scroll), this one flexes to fill its grid cell.
struct FocusAreaGridCard: View {

    let focusArea: FocusArea
    let action: () -> Void

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
                        .font(AppTypography.title2.bold())
                        .foregroundStyle(focusArea.status.color)
                        .monospacedDigit()

                    Text(focusArea.status.label)
                        .font(AppTypography.caption)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                Spacer(minLength: 0)

                progressBar
            }
            .padding(AppSpacing.cardPadding)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .buttonStyle(.plain)
        .cardBackground()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(focusArea.title), \(focusArea.percent) percent, \(focusArea.status.label)")
        .accessibilityHint("Opens \(focusArea.title) details")
    }

    private var iconBadge: some View {
        Image(systemName: focusArea.systemImage)
            .font(AppTypography.headline)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 36, height: 36)
            .background {
                RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                    .fill(Color.appPrimary.opacity(0.12))
            }
            .accessibilityHidden(true)
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
        .accessibilityHidden(true)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
        ForEach(FocusArea.sample) { area in
            FocusAreaGridCard(focusArea: area, action: {})
        }
    }
    .padding()
    .background(Color.appBackground)
}
