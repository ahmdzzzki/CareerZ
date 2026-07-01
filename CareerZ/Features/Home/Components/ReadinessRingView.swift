//
//  ReadinessRingView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

<<<<<<< HEAD
/// Circular progress ring showing career readiness percentage.
/// Reused in HomeView (compact) and CareerReadinessView (detail).
struct ReadinessRingView: View {

    let progress: Double // 0.0 - 1.0
    var lineWidth: CGFloat = 14
    var size: CGFloat = 140

    // Accessibility: respects Dynamic Type without distorting ring geometry.
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var percentText: String {
        "\(Int(progress * 100))%"
=======
struct ReadinessRingView: View {

    let progress: Double
    var lineWidth: CGFloat = 14
    var size: CGFloat = 140

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var normalizedProgress: Double {
        min(max(progress, 0), 1)
    }

    private var percentValue: Int {
        Int((normalizedProgress * 100).rounded())
    }

    private var progressColor: Color {
        switch percentValue {
        case 0..<40:
            return .appDanger
        case 40..<70:
            return .appWarning
        default:
            return .appSuccess
        }
    }
    private var statusText: String {
        switch percentValue {
        case 0..<40:
            return "Needs Focus"
        case 40..<70:
            return "Improving"
        default:
            return "Ready for Hire"
        }
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    }

    var body: some View {
        ZStack {
            Circle()
<<<<<<< HEAD
                .stroke(Color.appSecondaryFill, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.appSuccess,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(reduceMotion ? nil : .easeOut(duration: 0.8), value: progress)

            VStack(spacing: AppSpacing.xxs) {
                Text(percentText)
                    .font(AppTypography.largeTitle.bold())
                    .foregroundStyle(Color.appTextPrimary)
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            // Cap the ring's own intrinsic growth at very large Dynamic Type
            // sizes so it doesn't blow up layout; text inside still scales
            // via minimumScaleFactor instead of clipping.
            .padding(AppSpacing.sm)
=======
                .stroke(progressColor.opacity(0.14), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: normalizedProgress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(
                    reduceMotion ? nil : .easeOut(duration: 0.8),
                    value: normalizedProgress
                )

            Text("\(percentValue)%")
                .font(AppTypography.largeTitle.bold())
                .foregroundStyle(Color.appTextPrimary)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .padding(AppSpacing.sm)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Career readiness")
<<<<<<< HEAD
        .accessibilityValue("\(Int(progress * 100)) percent, ready for hire")
=======
        .accessibilityValue("\(percentValue) percent, \(statusText)")
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
<<<<<<< HEAD
        ReadinessRingView(progress: 0.75)
        ReadinessRingView(progress: 0.32, size: 100)
=======
        ReadinessRingView(progress: 0.28)
        ReadinessRingView(progress: 0.48)
        ReadinessRingView(progress: 0.68)
        ReadinessRingView(progress: 0.85, size: 100)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
    }
    .padding()
    .background(Color.appGroupedBackground)
}
