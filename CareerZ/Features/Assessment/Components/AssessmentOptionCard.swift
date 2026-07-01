//
//  AssessmentOptionCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct AssessmentOptionCard: View {
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Text(title)
                    .font(AppTypography.headline)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: AppSpacing.sm)
                
                selectionIndicator
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity, minHeight: 64)
            .background {
                shape.fill(
                    isSelected
                    ? Color.appPrimary.opacity(0.08)
                    : Color.appBackground
                )
            }
            .overlay {
                shape.stroke(
                    isSelected
                    ? Color.appPrimary
                    : Color.appSeparator.opacity(0.35),
                    lineWidth: isSelected ? 2 : 1
                )
            }
        }
        .buttonStyle(.plain)
        .contentShape(shape)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
    
    private var selectionIndicator: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected
                    ? Color.appPrimary
                    : Color.appTextTertiary.opacity(0.45),
                    lineWidth: 2
                )
                .frame(width: 24, height: 24)
            
            if isSelected {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 11, height: 11)
            }
        }
        .accessibilityHidden(true)
    }
}
