//
//  AppSearchField.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct AppSearchField: View {
    
    @Binding var text: String
    let prompt: String
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.secondary)
            
            TextField(prompt, text: $text)
                .font(AppTypography.body)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .frame(height: 48)
        .glassEffect(
            .clear.tint(Color.primary.opacity(0.04)),
            in: Capsule()
        )
        .overlay {
            Capsule()
                .stroke(Color.secondary.opacity(0.12), lineWidth: 1)
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        AppSearchField(
            text: .constant(""),
            prompt: "Search"
        )
        
        AppSearchField(
            text: .constant("Product"),
            prompt: "Search"
        )
    }
    .padding()
    .background(Color.appGroupedBackground)
}
