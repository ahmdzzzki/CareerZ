//
//  SectionHeaderView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Reusable "Section Title >" header row, tappable to navigate to a
/// full list screen. Used by Home (Focus Areas) and reusable wherever
/// a "see all" pattern appears (e.g. Roadmap).
struct SectionHeaderView: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xxs) {
                Text(title)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Image(systemName: "chevron.right")
                    .font(AppTypography.subheadline.bold())
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens all \(title.lowercased())")
    }
}

#Preview {
    SectionHeaderView(title: "Focus Areas", action: {})
        .padding()
        .background(Color.appGroupedBackground)
}
