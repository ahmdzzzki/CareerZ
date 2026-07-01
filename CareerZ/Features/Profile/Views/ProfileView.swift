//
//  ProfileView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Presented as a sheet from the avatar button on Home/Roadmap,
/// following the App Store/Books "account sheet" pattern rather than
/// being its own tab.
struct ProfileView: View {

    @State private var viewModel = ProfileViewModel()
    @Environment(\.dismiss) private var dismiss

    /// Placeholder destination for menu rows whose real screens
    /// (Career Goal detail, Assessment Results, Notifications
    /// settings, Help & Support, About) aren't built yet.
    @State private var selectedItem: ProfileMenuItem?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.sectionSpacing) {
                    header

                    menuSection(title: "CAREER", items: viewModel.careerItems)

                    menuSection(title: nil, items: [viewModel.notificationsItem])

                    menuSection(title: "ABOUT", items: viewModel.aboutItems)
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.screenVertical)
            }
            .background(Color.appGroupedBackground)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(AppTypography.subheadline.bold())
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    .accessibilityLabel("Close")
                }
            }
            .navigationDestination(item: $selectedItem) { item in
                // Placeholder until each destination screen exists.
                Text(item.title)
                    .navigationTitle(item.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: AppSpacing.md) {

            Image("ProfileAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.appBackground, lineWidth: 2)
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.userName)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Text("Account info and settings")
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.cardPadding)
        .cardBackground()
        .accessibilityElement(children: .combine)
    }
    
    private var profileHeader: some View {
        HStack(spacing: AppSpacing.md) {
            Image("ProfileAvatar")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.appBackground, lineWidth: 3)
                }

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(viewModel.userName)
                    .font(AppTypography.title3.bold())
                    .foregroundStyle(Color.appTextPrimary)

                Text("Account info and settings")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.cardPadding)
        .cardBackground()
        .accessibilityElement(children: .combine)
    }

    // MARK: - Menu section

    @ViewBuilder
    private func menuSection(title: String?, items: [ProfileMenuItem]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            if let title {
                Text(title)
                    .font(AppTypography.caption.bold())
                    .foregroundStyle(Color.appTextSecondary)
                    .accessibilityAddTraits(.isHeader)
            }

            VStack(spacing: 0) {
                ForEach(items) { item in
                    ProfileMenuRow(item: item, action: { selectedItem = item })

                    if item.id != items.last?.id {
                        Divider()
                            .padding(.leading, 28 + AppSpacing.sm)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.cardPadding)
            .cardBackground()
        }
    }
}

#Preview {
    ProfileView()
}
