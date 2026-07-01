//
//  HomeView.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @State private var path = NavigationPath()
    @State private var showProfile = false
    @State private var selectedNextStep: NextStep?

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.sectionSpacing) {
                    header

                    CareerReadinessCard(
                        progress: viewModel.readinessProgress,
                        monthlyDeltaPercent: viewModel.readinessMonthlyDelta,
                        action: { path.append(HomeRoute.careerReadiness) }
                    )

                    focusAreasSection

                    nextStepSection
                }
                .padding(.horizontal, AppSpacing.screenHorizontal)
                .padding(.vertical, AppSpacing.screenVertical)
            }
            .background(Color.appGroupedBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: HomeRoute.self) { route in
                destinationView(for: route)
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
            .sheet(item: $selectedNextStep) { step in
                NextStepDetailView(
                    nextStep: step,
                    onGoHome: {
                        selectedNextStep = nil
                        path.removeLast(path.count)
                    }
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(viewModel.greeting)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.appTextSecondary)

                HStack(spacing: AppSpacing.xs) {
                    Text(viewModel.userFirstName)
                        .font(AppTypography.title.bold())
                        .foregroundStyle(Color.appTextPrimary)
                    Text("👋")
                        .font(AppTypography.title)
                        .accessibilityHidden(true)
                }
            }

            Spacer()

            Button {
                showProfile = true
            } label: {
                Image("ProfileAvatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Color.appBackground, lineWidth: 2)
                    }
            }
            .accessibilityLabel("Profile")
            .accessibilityHint("Opens your profile")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(viewModel.greeting), \(viewModel.userFirstName)")
    }

    // MARK: - Focus Areas

    private var focusAreasSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            SectionHeaderView(title: "Focus Areas") {
                path.append(HomeRoute.focusAreaAll)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(viewModel.focusAreas) { area in
                        FocusAreaCard(
                            focusArea: area,
                            action: { path.append(HomeRoute.focusAreaDetail(area)) }
                        )
                    }
                }
                .padding(.leading, AppSpacing.screenHorizontal)
                .padding(.bottom, AppSpacing.xxs)
            }
            // Let the scroll view bleed to screen edges while content
            // still aligns with the rest of the page padding.
            .padding(.leading, -AppSpacing.screenHorizontal)
            .padding(.trailing, -AppSpacing.screenHorizontal)
        }
    }

    // MARK: - Next Step

    private var nextStepSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sectionHeaderBottom) {
            Text("Next Step")
                .font(AppTypography.title3.bold())
                .foregroundStyle(Color.appTextPrimary)

//            NextStepCard(
//                nextStep: viewModel.nextStep,
//                action: { path.append(HomeRoute.nextStepDetail(viewModel.nextStep)) }
//            )
            NextStepCard(
                nextStep: viewModel.nextStep,
                action: { selectedNextStep = viewModel.nextStep }
            )
        }
    }

    // MARK: - Routing

    @ViewBuilder
    private func destinationView(for route: HomeRoute) -> some View {
        switch route {
        case .careerReadiness:
            CareerReadinessView()
        case .focusAreaDetail(let area):
            FocusAreaDetailView(focusArea: area)
        case .focusAreaAll:
            FocusAreasView(onSelectArea: { area in path.append(HomeRoute.focusAreaDetail(area)) })
        }
    }
}

#Preview {
    HomeView()
}
