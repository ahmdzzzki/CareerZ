//
//  GoalOptionCard.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct GoalOptionCard: View {
    
    let goal: CareerGoalOption
    let isSelected: Bool
    let action: () -> Void
    
    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
    }
    
    private var iconShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous)
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                
                Image(systemName: goal.systemImage)
                    .font(.title3)
                    .foregroundStyle(goal.color)
                    .frame(width: 44, height: 44)
                    .glassEffect(
                        .clear.tint(goal.color.opacity(0.18)),
                        in: iconShape
                    )
                
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(goal.title)
                        .font(AppTypography.headline)
                        .foregroundStyle(.primary)
                    
                    Text(goal.subtitle)
                        .font(AppTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer(minLength: AppSpacing.sm)
                
                ZStack {
                    Circle()
                        .stroke(
                            isSelected
                            ? Color.appPrimary
                            : Color.secondary.opacity(0.35),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.appPrimary)
                            .frame(width: 11, height: 11)
                    }
                }
            }
            .padding(AppSpacing.md)
            .frame(maxWidth: .infinity)
            .glassEffect(
                .clear.tint(
                    isSelected
                    ? Color.appPrimary.opacity(0.10)
                    : Color.primary.opacity(0.04)
                ),
                in: cardShape
            )
            .overlay {
                cardShape.stroke(
                    isSelected
                    ? Color.appPrimary
                    : Color.secondary.opacity(0.10),
                    lineWidth: isSelected ? 2 : 1
                )
            }
        }
        .buttonStyle(.plain)
        .contentShape(cardShape)
        .accessibilityLabel(goal.title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: AppSpacing.sm) {
        GoalOptionCard(
            goal: CareerGoalOption(
                title: "Product Manager",
                subtitle: "Strategy, Roadmaps & Delivery",
                systemImage: "briefcase.fill",
                color: .blue,
                imageName: "productManager"
            ),
            isSelected: true,
            action: {}
        )
        
        GoalOptionCard(
            goal: CareerGoalOption(
                title: "Software Engineer",
                subtitle: "Development & Architecture",
                systemImage: "chevron.left.forwardslash.chevron.right",
                color: .cyan,
                imageName: "productManager"
            ),
            isSelected: false,
            action: {}
        )
    }
    .padding()
    .background(Color.appBackground)
}


