//
//  FocusAreaGridCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

<<<<<<< HEAD
/// Grid variant of the focus area card, used in the "Focus Areas All"
/// 2-column grid. Unlike FocusAreaCard (fixed width, horizontal
/// scroll), this one flexes to fill its grid cell.
=======
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
struct FocusAreaGridCard: View {

    let focusArea: FocusArea
    let action: () -> Void

<<<<<<< HEAD
=======
    private let minCardHeight: CGFloat = 172

>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                iconBadge

<<<<<<< HEAD
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
=======
                VStack(alignment: .leading, spacing: 2) {
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
                    Text(focusArea.title)
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("\(focusArea.percent)%")
<<<<<<< HEAD
                        .font(AppTypography.title2.bold())
=======
                        .font(AppTypography.title3.bold())
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
                        .foregroundStyle(focusArea.status.color)
                        .monospacedDigit()

                    Text(focusArea.status.label)
<<<<<<< HEAD
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
=======
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
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(focusArea.title), \(focusArea.percent) percent, \(focusArea.status.label)")
        .accessibilityHint("Opens \(focusArea.title) details")
    }

    private var iconBadge: some View {
        Image(systemName: focusArea.systemImage)
<<<<<<< HEAD
            .font(AppTypography.headline)
            .foregroundStyle(Color.appPrimary)
            .frame(width: 36, height: 36)
=======
            .font(AppTypography.headline.bold())
            .foregroundStyle(Color.appPrimary)
            .frame(width: 40, height: 40)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
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
<<<<<<< HEAD
                Capsule()
                    .fill(focusArea.status.color)
                    .frame(width: geo.size.width * CGFloat(focusArea.percent) / 100)
            }
        }
        .frame(height: 4)
=======

                Capsule()
                    .fill(focusArea.status.color)
                    .frame(
                        width: geo.size.width * CGFloat(focusArea.percent) / 100
                    )
            }
        }
        .frame(height: 5)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
        .accessibilityHidden(true)
    }
}

#Preview {
<<<<<<< HEAD
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppSpacing.sm) {
=======
    LazyVGrid(
        columns: [
            GridItem(.flexible(), spacing: AppSpacing.sm),
            GridItem(.flexible(), spacing: AppSpacing.sm)
        ],
        spacing: AppSpacing.sm
    ) {
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
        ForEach(FocusArea.sample) { area in
            FocusAreaGridCard(focusArea: area, action: {})
        }
    }
    .padding()
<<<<<<< HEAD
    .background(Color.appBackground)
=======
    .background(Color.appSecondaryBackground)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
}
