//
//  FocusAreaGridCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct FocusAreaGridCard: View {

    let focusArea: FocusArea
    let action: () -> Void

    private let minCardHeight: CGFloat = 172

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                iconBadge

                VStack(alignment: .leading, spacing: 2) {
                    Text(focusArea.title)
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(focusArea.percent)%")
                        .font(AppTypography.title3.bold())
                        .foregroundStyle(focusArea.status.color)
                        .monospacedDigit()

                    Text(focusArea.status.label)
                        .font(AppTypography.caption2)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                }

                progressBar
                    .padding(.top, AppSpacing.xs)
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, minHeight: minCardHeight, alignment: .topLeading)
        }
        .buttonStyle(.plain)
        .cardBackground(cornerRadius: AppRadius.md)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(focusArea.title), \(focusArea.percent) percent, \(focusArea.status.label)")
        .accessibilityHint("Opens \(focusArea.title) details")
    }

    private var iconBadge: some View {
        Image(systemName: focusArea.systemImage)
            .font(AppTypography.headline.bold())
            .foregroundStyle(Color.appPrimary)
            .frame(width: 40, height: 40)
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
                    .frame(
                        width: geo.size.width * CGFloat(focusArea.percent) / 100
                    )
            }
        }
        .frame(height: 5)
        .accessibilityHidden(true)
    }
}

#Preview {
    LazyVGrid(
        columns: [
            GridItem(.flexible(), spacing: AppSpacing.sm),
            GridItem(.flexible(), spacing: AppSpacing.sm)
        ],
        spacing: AppSpacing.sm
    ) {
        ForEach(FocusArea.sample) { area in
            FocusAreaGridCard(focusArea: area, action: {})
        }
    }
    .padding()
    .background(Color.appSecondaryBackground)
}
