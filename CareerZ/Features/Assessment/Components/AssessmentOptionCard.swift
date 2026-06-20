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
        RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.appPrimary : Color.secondary.opacity(0.35),
                            lineWidth: 2
                        )
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background {
                shape.fill(.regularMaterial)
            }
            .overlay {
                shape.stroke(
                    isSelected ? Color.appPrimary : Color.secondary.opacity(0.12),
                    lineWidth: isSelected ? 2 : 1
                )
            }
        }
        .buttonStyle(.plain)
        .contentShape(shape)
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
    }
}
