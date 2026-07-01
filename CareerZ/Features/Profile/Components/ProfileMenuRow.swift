

//
//  ProfileMenuRow.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// One row inside a Profile menu section, e.g. "Career Goal —
/// Product Manager >".
struct ProfileMenuRow: View {

    let item: ProfileMenuItem
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: item.systemImage)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appPrimary)
                    .frame(width: 28, height: 28)
                    .background {
                        RoundedRectangle(cornerRadius: AppRadius.sm, style: .continuous)
                            .fill(Color.appPrimary.opacity(0.12))
                    }
                    .accessibilityHidden(true)

                Text(item.title)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextPrimary)

                Spacer(minLength: AppSpacing.xs)

                if let trailingValue = item.trailingValue {
                    Text(trailingValue)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(Color.appTextSecondary)
                        .lineLimit(1)
                }

                Image(systemName: "chevron.right")
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextTertiary)
            }
            .padding(.vertical, AppSpacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.trailingValue.map { "\(item.title), \($0)" } ?? item.title)
        .accessibilityHint("Opens \(item.title)")
    }
}

#Preview {
    VStack(spacing: 0) {
        ProfileMenuRow(
            item: ProfileMenuItem(id: "goal", title: "Career Goal", systemImage: "target", trailingValue: "Product Manager"),
            action: {}
        )
        Divider()
        ProfileMenuRow(
            item: ProfileMenuItem(id: "results", title: "Assessment Results", systemImage: "doc.text"),
            action: {}
        )
    }
    .padding()
    .cardBackground()
    .padding()
    .background(Color.appGroupedBackground)
}
