//
//  ExpandableSection.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Single collapsible section with a chevron-down indicator, e.g.
/// "Why does Networking matter?". Distinct from ExpandableInfoRow's
/// chevron-right accordion list style — this is a standalone toggle.
struct ExpandableSection: View {

    let title: String
    let detail: String

    @State private var isExpanded: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .font(AppTypography.subheadline.bold())
                        .foregroundStyle(Color.appTextPrimary)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: AppSpacing.xs)

                    Image(systemName: "chevron.down")
                        .font(AppTypography.caption.bold())
                        .foregroundStyle(Color.appTextSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.vertical, AppSpacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(title)
            .accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")
            .accessibilityAddTraits(.isButton)

            if isExpanded {
                Text(detail)
                    .font(AppTypography.footnote)
                    .foregroundStyle(Color.appTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, AppSpacing.sm)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, AppSpacing.cardPadding)
        .cardBackground()
    }
}

#Preview {
    ExpandableSection(
        title: "Why does Networking matter?",
        detail: "Networking helps you discover opportunities, learn from professionals, and build meaningful industry relationships."
    )
    .padding()
    .background(Color.appGroupedBackground)
}
