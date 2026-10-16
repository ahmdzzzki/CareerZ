import SwiftUI

struct DiscoveryView: View {
    @Bindable var store: JourneyStore
    let onDevelop: () -> Void
    @State private var showAssessment = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    Text("What’s your direction?").font(AppTypography.largeTitle.bold())
                    Text("Explore the paths that interest you. Choose a direction to build your own roadmap.").foregroundStyle(Color.appTextSecondary)
                    HStack(spacing: AppSpacing.md) {
                        Image("OnboardingIntro").resizable().scaledToFill().frame(width: 90, height: 106).clipShape(RoundedRectangle(cornerRadius: AppRadius.lg)).accessibilityHidden(true)
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("CareerZ Compass").font(AppTypography.title3.bold())
                            Text("Not sure where to start? Let your interests point you toward a few paths to explore.").font(AppTypography.callout).foregroundStyle(Color.appTextSecondary)
                        }
                    }.padding(AppSpacing.lg).journeyCard()
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
                            }.padding(AppSpacing.lg).journeyCard()
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
                            HStack(spacing: AppSpacing.md) {
                                JourneyIcon(name: JourneyAppearance.icon(domain), color: JourneyAppearance.color(domain))
                                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                    Text(domain.title).font(AppTypography.headline).foregroundStyle(Color.appTextPrimary)
                                    Text(JourneyAppearance.subtitle(domain)).font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: store.selectedDomain == domain ? "largecircle.fill.circle" : "circle")
                                    .font(AppTypography.title2).foregroundStyle(store.selectedDomain == domain ? Color.appPrimary : Color.appSeparator)
                            }.padding(AppSpacing.lg).journeyCard()
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
    @Environment(\.dismiss) private var dismiss
    @State private var showConfirmation = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                HStack(spacing: AppSpacing.md) {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Explore this direction").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        Text(domain.title).font(AppTypography.title.bold())
                        Text(JourneyAppearance.subtitle(domain)).font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                    }
                    Spacer(minLength: 0)
                    if domain == .productManagement { Image("productManager").resizable().scaledToFit().frame(width: 100).accessibilityHidden(true) }
                    else { JourneyIcon(name: JourneyAppearance.icon(domain), color: JourneyAppearance.color(domain), size: 64) }
                }.padding(AppSpacing.lg).journeyCard()
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
                Text(JourneyCopy.experiment(domain)).padding(AppSpacing.lg).journeyCard()
                if domain != .productManagement {
                    Text("You can explore this direction now. Its skill-development content is not available yet; Product Management is the first pilot.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
                AppButton(title: "Choose this direction", action: { showConfirmation = true }, systemImage: "arrow.right")
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground)
        .alert("Explore \(domain.title)?", isPresented: $showConfirmation) {
            Button("Choose direction") { if store.choose(domain) { onDevelop(); dismiss() } }
            Button("Cancel", role: .cancel) {}
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
                    }.padding(AppSpacing.lg).journeyCard()
                }
                Text("Consider what felt energizing, what you wanted to learn more about, and what feedback you received. Your experience can matter more than a small difference in match scores.")
                    .foregroundStyle(Color.appTextSecondary)
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("Compare directions").navigationBarTitleDisplayMode(.inline)
    }
}
