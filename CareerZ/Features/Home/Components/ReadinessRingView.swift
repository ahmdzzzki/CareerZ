//
//  ReadinessRingView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

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
    }

    var body: some View {
        ZStack {
            Circle()
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
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Career readiness")
        .accessibilityValue("\(percentValue) percent, \(statusText)")
    }
}

#Preview {
    VStack(spacing: AppSpacing.xl) {
        ReadinessRingView(progress: 0.28)
        ReadinessRingView(progress: 0.48)
        ReadinessRingView(progress: 0.68)
        ReadinessRingView(progress: 0.85, size: 100)
    }
    .padding()
    .background(Color.appGroupedBackground)
}
