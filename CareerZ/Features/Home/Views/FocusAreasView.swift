//
//  FocusAreasView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct FocusAreasView: View {

    @State private var viewModel = FocusAreasViewModel()
    @Environment(\.dismiss) private var dismiss

    let onSelectArea: (FocusArea) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.sm),
        GridItem(.flexible(), spacing: AppSpacing.sm),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppSpacing.sm) {
                ForEach(viewModel.focusAreas) { area in
                    FocusAreaGridCard(
                        focusArea: area,
                        action: { onSelectArea(area) }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.screenHorizontal)
            .padding(.top, AppSpacing.screenVertical)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appSecondaryBackground)
        .navigationTitle("Focus Areas")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundStyle(Color.appTextPrimary)
        }
        .accessibilityLabel("Back")
    }
}

#Preview {
    NavigationStack {
        FocusAreasView(onSelectArea: { _ in })
    }
}
