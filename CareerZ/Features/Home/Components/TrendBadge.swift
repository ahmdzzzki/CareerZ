//
//  TrendBadge.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Small pill badge with an icon + text, e.g. "+5% this month" or
/// "+5% Readiness". Color is adaptive (system color + opacity), no hex.
struct TrendBadge: View {

    let text: String
    var systemImage: String = "arrow.up.right"
    var color: Color = .appSuccess

    var body: some View {
        HStack(spacing: AppSpacing.xxs) {
            Image(systemName: systemImage)
                .font(AppTypography.caption2.bold())
            Text(text)
                .font(AppTypography.caption.bold())
        }
        .foregroundStyle(color)
        .padding(.horizontal, AppSpacing.xs)
        .padding(.vertical, AppSpacing.xxs)
        .background {
            Capsule()
                .fill(color.opacity(0.15))
        }
        // Decorative icon + text read as one phrase, no need to split.
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        TrendBadge(text: "+5% this month")
        TrendBadge(text: "+5% Readiness", systemImage: "bolt.fill", color: .appInfo)
    }
    .padding()
    .background(Color.appGroupedBackground)
}
