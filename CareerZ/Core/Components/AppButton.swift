//
//  AppButton.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

//
//  AppButton.swift
//  CareerZ
//

import SwiftUI

struct AppButton: View {
    
    let title: String
    let action: () -> Void
    
    var systemImage: String? = nil
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Label {
                Text(title)
                    .font(AppTypography.headline)
            } icon: {
                if let systemImage {
                    Image(systemName: systemImage)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .foregroundStyle(isEnabled ? .white : .secondary)
            .background {
                Capsule()
                    .fill(isEnabled ? Color.appPrimary : Color.appSecondaryFill)
            }
            .glassEffect(
                .clear,
                in: Capsule()
            )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        AppButton(title: "Get Started", action: {})
        AppButton(title: "Continue", action: {}, systemImage: "arrow.right")
        AppButton(title: "Disabled", action: {}, isEnabled: false)
    }
    .padding()
    .background(Color.appGroupedBackground)
}
