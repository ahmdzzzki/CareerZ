import SwiftUI

struct JourneyDashboardView: View {
    @Bindable var store: JourneyStore
    let onDiscover: () -> Void
    let onRoadmap: () -> Void
    @AppStorage("displayName") private var displayName = ""
    @State private var assessment = false
    @State private var profile = false
    @AppStorage("hasCompletedOnboarding") private var onboarded = false
    @Environment(\.dynamicTypeSize) private var typeSize
    private var proficiency: Double? {
        store.latestSkillSession.flatMap { SkillHistoryService().weightedProficiency(skills: store.skills, session: $0) }.map { $0 / 4 }
    }
    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: "Good Morning"
        case 12..<17: "Good Afternoon"
        default: "Good Evening"
        }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    HStack {
                        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                            Text(greeting).font(AppTypography.subheadline).foregroundStyle(Color.appTextSecondary)
                            Text(displayName.isEmpty ? "Your career journey" : "\(displayName) 👋").font(AppTypography.title.bold())
                        }
                        Spacer()
                        Button { profile = true } label: {
                            Image(systemName: "person.crop.circle.fill").font(.system(size: 42)).foregroundStyle(Color.appPrimary)
                                .padding(3).background(Color.appCardBackground, in: Circle())
                        }.accessibilityLabel("Profile")
                    }
                    NavigationLink { SkillHistoryView(store: store) } label: {
                        Group {
                            if typeSize.isAccessibilitySize {
                                VStack(alignment: .leading, spacing: AppSpacing.lg) { snapshotCopy; snapshotRing }
                            } else {
                                HStack(spacing: AppSpacing.md) {
                                    snapshotCopy.frame(maxWidth: .infinity, alignment: .leading)
                                    snapshotRing
                                }
                            }
                        }.frame(maxWidth: .infinity, alignment: .leading).padding(AppSpacing.lg).journeyCard()
                    }.buttonStyle(.plain)
                    if let domain = store.selectedDomain {
                        HStack(spacing: AppSpacing.sm) {
                            JourneyIcon(name: JourneyAppearance.icon(domain), size: 40)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Your direction").font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                                Text(domain.title).font(AppTypography.subheadline.bold())
                            }
                            Spacer()
                            Button("Explore") { onDiscover() }.font(AppTypography.subheadline).frame(minHeight: 44)
                        }
                    }
                    HStack {
                        Text(store.selectedDomain == nil ? "Explore Career Paths" : store.latestSkillSession == nil ? "Skills to Explore" : "Focus Areas").font(AppTypography.title2.bold())
                        Spacer()
                        if store.selectedDomain == nil {
                            Button(action: onDiscover) { Image(systemName: "chevron.right") }.accessibilityLabel("Explore all careers")
                        } else {
                            NavigationLink { SkillHistoryView(store: store) } label: { Image(systemName: "chevron.right") }.accessibilityLabel("View all skills")
                        }
                    }
                    skillCarousel
                    Text("Next Step").font(AppTypography.title2.bold())
                    nextStep
                    HStack {
                        Text("Your Roadmap").font(AppTypography.title2.bold())
                        Spacer()
                        Button { onRoadmap() } label: { Image(systemName: "chevron.right") }.accessibilityLabel("Open roadmap")
                    }
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        HStack(spacing: AppSpacing.md) {
                            JourneyIcon(name: "map")
                            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                Text(store.latestSkillSession == nil ? "Foundation → Practice → Portfolio" : "\(store.completedIDs.count) of \(store.missions.count) completed")
                                    .font(AppTypography.headline)
                                Text(store.latestSkillSession == nil ? "Build an honest starting point first." : "Evidence, reflection, and small steps forward.")
                                    .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                            }
                        }
                        if store.latestSkillSession != nil { ProgressView(value: store.progress).tint(.appPrimary).accessibilityLabel("Roadmap completion") }
                        Button(store.latestSkillSession == nil ? "Explore your roadmap" : "Continue your journey") { onRoadmap() }.frame(minHeight: 44)
                    }.padding(AppSpacing.lg).journeyCard()

                }.padding(.horizontal, AppSpacing.screenHorizontal).padding(.vertical, AppSpacing.md)
            }.background(Color.appGroupedBackground).toolbar(.hidden, for: .navigationBar)
                .sheet(isPresented: $assessment) { JourneyAssessmentView(store: store, kind: .skills) }
                .sheet(isPresented: $profile) { JourneySettingsView(store: store, onDelete: { profile = false; onboarded = false }) }
        }
    }
    private var snapshotRing: some View { JourneyRing(progress: proficiency, color: proficiency == nil ? .appPrimary : .appSuccess) }
    private var snapshotCopy: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(store.selectedDomain.map { "\($0.shortTitle) Skill Snapshot" } ?? "Skill Snapshot").font(AppTypography.title3.bold()).foregroundStyle(Color.appTextPrimary)
            Text(proficiency == nil ? "Find your starting point" : "Self-assessed proficiency").font(AppTypography.subheadline).foregroundStyle(Color.appTextSecondary)
            if let latest = store.latestSkillSession, store.skillHistory.count > 1,
               latest.contentVersion == store.skillHistory[1].contentVersion, latest.domain == store.skillHistory[1].domain,
               let previous = SkillHistoryService().weightedProficiency(skills: store.skills, session: store.skillHistory[1]),
               let current = SkillHistoryService().weightedProficiency(skills: store.skills, session: latest) {
                let delta = (current - previous) / 4 * 100
                Label("\(delta >= 0 ? "+" : "")\(delta.formatted(.number.precision(.fractionLength(0)))) pts since last assessment", systemImage: delta >= 0 ? "arrow.up.right" : "arrow.down.right")
                    .font(AppTypography.caption.bold()).foregroundStyle(delta >= 0 ? Color.appSuccess : Color.appWarning)
                    .padding(.horizontal, AppSpacing.sm).padding(.vertical, AppSpacing.xs)
                    .background((delta >= 0 ? Color.appSuccess : Color.appWarning).opacity(0.12), in: Capsule())
            } else {
                Label(proficiency == nil ? "Not assessed yet" : "Your first baseline", systemImage: "checklist")
                    .font(AppTypography.caption).foregroundStyle(Color.appPrimary)
            }
        }
    }
    private var skillCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                if store.selectedDomain == nil {
                    ForEach(CareerDomainID.allCases) { domain in
                        NavigationLink { CareerDirectionView(store: store, domain: domain, match: nil, onDevelop: onRoadmap) } label: {
                            VStack(alignment: .leading, spacing: AppSpacing.md) {
                                JourneyIcon(name: JourneyAppearance.icon(domain), color: JourneyAppearance.color(domain))
                                Text(domain.title).font(AppTypography.headline).foregroundStyle(Color.appTextPrimary)
                                Text("Explore this direction").font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                            }.padding(AppSpacing.md).frame(width: typeSize.isAccessibilitySize ? 260 : 176, alignment: .leading).frame(minHeight: 210, alignment: .top).journeyCard()
                        }.buttonStyle(.plain)
                    }
                } else {
                    ForEach(store.priorityGaps.isEmpty ? Array(store.skills.prefix(3)) : store.priorityGaps.map(\.skill)) { skill in
                        NavigationLink { JourneySkillDetailView(store: store, skill: skill) } label: {
                            JourneySkillTile(skill: skill, result: store.latestSkillSession?.results.first { $0.skillID == skill.id })
                                .frame(width: typeSize.isAccessibilitySize ? 260 : 176)
                        }.buttonStyle(.plain)
                    }
                }
            }.padding(.bottom, AppSpacing.xxs)
        }
    }
    private var nextStep: some View {
        Button {
            if store.selectedDomain != nil {
                if store.latestSkillSession == nil { assessment = true } else { onRoadmap() }
            } else { onDiscover() }
        } label: {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                HStack(spacing: AppSpacing.md) {
                    Image("Assessment").resizable().scaledToFit().frame(width: 76, height: 90).accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(store.selectedDomain != nil ? (store.latestSkillSession == nil ? "\(store.activeDomain.shortTitle) Assessment" : "Your Next Mission") : "Find Your Direction")
                            .font(AppTypography.title3.bold())
                        Text(store.selectedDomain != nil ? (store.latestSkillSession == nil ? "Check your skills and build your personal roadmap." : "Turn your next priority into a reviewable piece of work.") : "Explore your interests, compare careers, and choose where to start.")
                            .font(AppTypography.callout).foregroundStyle(Color.appTextSecondary)
                    }
                    Spacer(minLength: 0)
                }
                Divider()
                HStack(spacing: AppSpacing.lg) {
                    Label(store.selectedDomain != nil ? "8 skills" : "6 directions", systemImage: "list.bullet")
                    Label("On-device", systemImage: "iphone")
                    Spacer(); Image(systemName: "arrow.right").foregroundStyle(Color.appPrimary)
                }.font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
            }.padding(AppSpacing.lg).journeyCard()
        }.buttonStyle(.plain)
    }
}

struct JourneySkillTile: View {
    let skill: SkillDefinition
    let result: SkillAssessmentResult?
    private var color: Color {
        guard let result else { return .appPrimary }
        return result.calculatedScore >= skill.portfolioTarget ? .appSuccess : result.calculatedScore >= 2 ? .appWarning : .appDanger
    }
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            JourneyIcon(name: JourneyAppearance.skillIcon(skill.title))
            Text(skill.title).font(AppTypography.headline).foregroundStyle(Color.appTextPrimary).fixedSize(horizontal: false, vertical: true)
            Text(result.map { "\($0.calculatedScore.formatted(.number.precision(.fractionLength(1)))) / 4" } ?? "—")
                .font(AppTypography.title2.bold()).foregroundStyle(color).monospacedDigit()
            Text(result == nil ? "Not assessed" : result!.calculatedScore >= skill.portfolioTarget ? "At portfolio target" : "Room to develop")
                .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
            ProgressView(value: (result?.calculatedScore ?? 0) / 4).tint(color).accessibilityLabel(skill.title)
        }.padding(AppSpacing.md).frame(maxWidth: .infinity, alignment: .leading).frame(minHeight: 230, alignment: .top).journeyCard()
    }
}

struct JourneySkillDetailView: View {
    @Bindable var store: JourneyStore
    let skill: SkillDefinition
    private var result: SkillAssessmentResult? { store.latestSkillSession?.results.first { $0.skillID == skill.id } }
    @State private var capabilityExpanded = false
    @State private var evidenceExpanded = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                HStack(spacing: AppSpacing.md) {
                    JourneyIcon(name: JourneyAppearance.skillIcon(skill.title), size: 64)
                    VStack(alignment: .leading, spacing: AppSpacing.xs) { Text(skill.title).font(AppTypography.title3.bold()); Text("Portfolio target \(skill.portfolioTarget.formatted()) / 4").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary) }
                    Spacer(minLength: 0)
                    Text(result.map { $0.calculatedScore.formatted(.number.precision(.fractionLength(1))) } ?? "—").font(AppTypography.title.bold()).foregroundStyle(Color.appPrimary)
                }.padding(AppSpacing.lg).journeyCard()
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Label("Insight", systemImage: "sparkles").font(AppTypography.headline).foregroundStyle(Color.appPrimary)
                    Text(skill.summary).foregroundStyle(Color.appTextSecondary)
                    if let result {
                        Text(JourneyEngine().recommendation(for: SkillGapResult(skill: skill, currentScore: result.calculatedScore, gap: max(skill.portfolioTarget - result.calculatedScore, 0), priorityScore: 0)))
                    } else { Text("Complete your skill assessment to see an insight based on your answers.") }
                }.padding(AppSpacing.lg).journeyCard()
                Text("Measured By").font(AppTypography.title2.bold())
                VStack {
                    ExpandableInfoRow(title: "Capability", systemImage: "gearshape", trailingBadgeText: result.map { "\($0.capabilityLevel) / 4" }, detail: "What you can apply independently. Capability contributes 60% of your skill score.", isExpanded: capabilityExpanded, onToggle: { capabilityExpanded.toggle() })
                    Divider()
                    ExpandableInfoRow(title: "Evidence", systemImage: "doc.text", trailingBadgeText: result.map { "\($0.evidenceLevel) / 4" }, detail: "Reviewable work, feedback, and outcomes. Evidence contributes 40% of your skill score.", isExpanded: evidenceExpanded, onToggle: { evidenceExpanded.toggle() })
                }.padding(AppSpacing.lg).journeyCard()
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    Label("Evidence to build", systemImage: "lightbulb").font(AppTypography.headline).foregroundStyle(Color.appPrimary)
                    ForEach(skill.evidenceExamples, id: \.self) { example in Label(example, systemImage: "checkmark.seal").foregroundStyle(Color.appTextSecondary) }
                }.padding(AppSpacing.lg).journeyCard()
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("Skill Detail").navigationBarTitleDisplayMode(.inline)
    }
}
