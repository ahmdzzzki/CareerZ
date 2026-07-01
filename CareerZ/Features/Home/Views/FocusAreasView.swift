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

<<<<<<< HEAD
    /// Called when a card is tapped. The presenting screen owns
    /// navigation (e.g. appends to its NavigationPath), keeping this
    /// view decoupled from any specific route type.
=======
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
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
<<<<<<< HEAD
            .padding(.vertical, AppSpacing.screenVertical)
        }
        .background(Color.appBackground)
=======
            .padding(.top, AppSpacing.screenVertical)
            .padding(.bottom, AppSpacing.xl)
        }
        .background(Color.appSecondaryBackground)
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
        .navigationTitle("Focus Areas")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
<<<<<<< HEAD
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.appTextPrimary)
                }
                .accessibilityLabel("Back")
            }
        }
    }
=======
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
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
}

#Preview {
    NavigationStack {
        FocusAreasView(onSelectArea: { _ in })
    }
}
