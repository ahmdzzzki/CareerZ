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
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(AppTypography.title3)
                .foregroundStyle(Color.appTextSecondary)
                .accessibilityHidden(true)
            
            TextField(prompt, text: $text)
                .font(AppTypography.body)
                .focused(isFocused)
                .submitLabel(.done)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onSubmit {
                    isFocused.wrappedValue = false
                }
            
            if !text.isEmpty {
                Button {
                    text = ""
                    isFocused.wrappedValue = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(Color.appTextSecondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear search")
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
                .stroke(Color.appSeparator.opacity(0.6), lineWidth: 1)
        }
        .accessibilityLabel("Search")
    }
}

#Preview {
    SearchFieldPreview()
}

private struct SearchFieldPreview: View {
    @State private var text = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            AppSearchField(
                text: $text,
                prompt: "Search",
                isFocused: $isFocused
            )
        }
        .padding()
        .background(Color.appSecondaryBackground)
    }
}
