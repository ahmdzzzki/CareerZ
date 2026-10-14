import SwiftUI

struct DiscoveryView: View {
    @Bindable var store: JourneyStore
    let onDevelop: () -> Void
    @State private var showAssessment = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    Text("Find a direction.\nKeep your options open.").font(AppTypography.largeTitle.bold())
                    Text("Compass reflects your answers about interests and tendencies. It suggests experiments—not a fixed career label.")
                        .foregroundStyle(Color.appTextSecondary)
                    if let latest = store.compassHistory.first {
                        HStack { Label("Your Compass", systemImage: "safari"); Spacer(); Text(latest.assessedAt, style: .date).font(AppTypography.caption) }
                        if latest.hasCloseLeaders {
                            Text("Your leading directions are close. Explore both before making a choice.")
                                .font(AppTypography.callout).padding(AppSpacing.md).cardBackground()
                        }
                        ForEach(Array(latest.matches.prefix(3))) { match in
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                NavigationLink { CareerDirectionView(store: store, domain: match.domain, match: match, onDevelop: onDevelop) } label: {
                                    HStack { Text(match.domain.title).font(AppTypography.headline); Spacer(); Image(systemName: "chevron.right") }
                                }
                                Text("Compass Match: \(match.score.formatted(.number.precision(.fractionLength(0)))) / 100")
                                    .font(AppTypography.subheadline).foregroundStyle(Color.appTextSecondary)
                                ForEach(Array(match.contributions.prefix(3))) { contribution in
                                    Text("\(contribution.trait.title): \(contribution.score.formatted(.number.precision(.fractionLength(0)))) / 100")
                                        .font(AppTypography.caption)
                                }
                            }.padding(AppSpacing.cardPadding).cardBackground()
                        }
                        NavigationLink("Compare leading directions") {
                            CareerComparisonView(matches: Array(latest.matches.prefix(2)))
                        }.frame(minHeight: 44)
                        Text("Match is a weighted reflection of your answers, not a probability of success. Higher contributions explain the ordering.")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                    } else {
                        Label("No Compass assessment yet", systemImage: "safari").font(AppTypography.headline)
                        Text("40 short statements. There are no right answers. Think about how you usually behave, rather than who you feel you should be.")
                    }
                    AppButton(title: store.compassHistory.isEmpty ? "Take CareerZ Compass" : "Retake Compass", action: { showAssessment = true }, systemImage: "safari")
                    Text("Explore all directions").font(AppTypography.title2.bold())
                    Text("Already curious about a path? You can choose it directly. Selecting a direction keeps your past assessments and PM progress.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                    ForEach(CareerDomainID.allCases) { domain in
                        NavigationLink {
                            CareerDirectionView(store: store, domain: domain, match: store.compassHistory.first?.matches.first { $0.domain == domain }, onDevelop: onDevelop)
                        } label: {
                            HStack { Text(domain.title); Spacer(); if store.selectedDomain == domain { Image(systemName: "checkmark.circle.fill") }; Image(systemName: "chevron.right") }
                                .padding(AppSpacing.md).cardBackground()
                        }
                    }
                }.padding(AppSpacing.screenHorizontal)
            }
            .background(Color.appGroupedBackground).navigationTitle("Discover")
            .sheet(isPresented: $showAssessment) { JourneyAssessmentView(store: store, kind: .compass) }
        }
    }
}

struct CareerDirectionView: View {
    @Bindable var store: JourneyStore
    let domain: CareerDomainID
    let match: CompassMatch?
    let onDevelop: () -> Void
    @State private var showConfirmation = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Text(domain.title).font(AppTypography.largeTitle.bold())
                Text("A direction worth exploring. You can change your mind as you learn.").foregroundStyle(Color.appTextSecondary)
                if let match {
                    Text("Compass Match: \(match.score.formatted(.number.precision(.fractionLength(0)))) / 100").font(AppTypography.headline)
                    Text("Why it appeared").font(AppTypography.title3.bold())
                    ForEach(Array(match.contributions.prefix(3))) { item in
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(item.trait.title).font(AppTypography.headline)
                            Text("Your trait score \(item.score.formatted(.number.precision(.fractionLength(0)))) / 100 contributes \(item.contribution.formatted(.number.precision(.fractionLength(1)))) points to this match.")
                                .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        }
                    }
                    Text("These are the largest weighted contributions, which are influenced by both your answers and this domain’s weights. A low match does not exclude a career.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
                Text("Try this direction").font(AppTypography.title2.bold())
                Text(JourneyCopy.experiment(domain)).padding(AppSpacing.cardPadding).cardBackground()
                if domain != .productManagement {
                    Text("You can explore this direction now. Its skill-development content is not available yet; Product Management is the first pilot.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
                AppButton(title: "Choose this direction", action: { showConfirmation = true }, systemImage: "arrow.right")
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground)
        .confirmationDialog("Explore \(domain.title)?", isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Choose direction") { if store.choose(domain) { onDevelop() } }
        } message: { Text("Your assessment history and existing Product Management mission evidence will be kept.") }
    }
}

struct CareerComparisonView: View {
    let matches: [CompassMatch]
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Text("A match is an invitation, not a verdict.").font(AppTypography.title.bold())
                Text("Compare the signals and try a small experiment in each direction. The same trait can carry different weight in different domains.")
                    .foregroundStyle(Color.appTextSecondary)
                ForEach(matches) { match in
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text(match.domain.title).font(AppTypography.title2.bold())
                        Text("Compass Match: \(match.score.formatted(.number.precision(.fractionLength(0)))) / 100")
                        ForEach(match.contributions) { item in
                            HStack(alignment: .top) {
                                Text(item.trait.title)
                                Spacer()
                                Text("\(item.contribution.formatted(.number.precision(.fractionLength(1)))) pts")
                                    .monospacedDigit()
                            }.font(AppTypography.footnote)
                        }
                        Text("Try: \(JourneyCopy.experiment(match.domain))").font(AppTypography.callout)
                    }.padding(AppSpacing.cardPadding).cardBackground()
                }
                Text("Consider what felt energizing, what you wanted to learn more about, and what feedback you received. Your experience can matter more than a small difference in match scores.")
                    .foregroundStyle(Color.appTextSecondary)
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("Compare directions").navigationBarTitleDisplayMode(.inline)
    }
}
