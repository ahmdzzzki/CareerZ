import SwiftUI

struct DevelopmentView: View {
    @Bindable var store: JourneyStore
    var onDiscover: () -> Void = {}
    @State private var assessment = false
    @State private var profile = false
    @AppStorage("hasCompletedOnboarding") private var onboarded = false
    private var nextMission: MissionPlan? { store.roadmap.first { !store.completedIDs.contains($0.id) && store.isUnlocked($0.mission) } }
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text(store.selectedDomain?.roadmapTitle ?? "Your Career Roadmap").font(AppTypography.title2.bold())
                            Text("Your personalized growth path").foregroundStyle(Color.appTextSecondary)
                        }
                        Spacer(minLength: AppSpacing.sm)
                        Button { profile = true } label: { Image(systemName: "person.crop.circle.fill").font(.system(size: 42)).foregroundStyle(Color.appPrimary) }.accessibilityLabel("Profile")
                    }
                    if store.selectedDomain != nil {
                        domainJourney
                    } else {
                        VStack(spacing: AppSpacing.lg) {
                            Image("OnboardingIntro").resizable().scaledToFit().frame(height: 170).accessibilityHidden(true)
                            Text("Choose your direction").font(AppTypography.title2.bold())
                            Text("Six career paths. A practical roadmap for the skills you want to develop.").foregroundStyle(Color.appTextSecondary)
                            AppButton(title: "Explore career directions", action: onDiscover)
                        }.padding(AppSpacing.xl).journeyCard()
                    }
                }.padding(.horizontal, AppSpacing.screenHorizontal).padding(.vertical, AppSpacing.md)
            }.id(store.selectedDomain).background(Color.appGroupedBackground).toolbar(.hidden, for: .navigationBar)
                .sheet(isPresented: $assessment) { JourneyAssessmentView(store: store, kind: .skills) }
                .sheet(isPresented: $profile) { JourneySettingsView(store: store, onDelete: { profile = false; onboarded = false }) }
        }
    }
    @ViewBuilder private var domainJourney: some View {
        if store.latestSkillSession != nil {
            HStack(spacing: AppSpacing.md) {
                JourneyIcon(name: "person.badge.key", size: 52)
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text("Current Stage").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                    Text(nextMission?.mission.stage.rawValue.capitalized ?? "Portfolio").font(AppTypography.title3.bold()).foregroundStyle(Color.appPrimary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                    Text("\(store.completedIDs.count) of \(store.missions.count)").font(AppTypography.title2.bold()).foregroundStyle(Color.appPrimary)
                    Text("Completed").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
            }.padding(AppSpacing.lg).journeyCard()
            if let nextMission {
                NavigationLink { MissionActivityView(store: store, item: nextMission) } label: {
                    HStack(spacing: AppSpacing.md) {
                        JourneyIcon(name: "sparkles", size: 54)
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Recommended Next Step").font(AppTypography.footnote).foregroundStyle(Color.appPrimary)
                            Text(nextMission.mission.title).font(AppTypography.headline).foregroundStyle(Color.appTextPrimary)
                            Text(nextMission.classification.rawValue).font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                        }
                        Spacer(minLength: 0); Image(systemName: "arrow.right").font(AppTypography.title3).foregroundStyle(Color.appPrimary)
                    }.padding(AppSpacing.lg).background(Color.appPrimary.opacity(0.12), in: RoundedRectangle(cornerRadius: AppRadius.xxl))
                }.buttonStyle(.plain)
            } else {
                Label("Every mission completed. Reflect on your work and reassess your skills.", systemImage: "trophy.fill")
                    .foregroundStyle(Color.appSuccess).padding(AppSpacing.lg).journeyCard()
            }
            Text("Roadmap Progress").font(AppTypography.headline).foregroundStyle(Color.appTextSecondary)
            Text("\(store.completedIDs.count) of \(store.missions.count) missions completed · \(Int((store.progress * 100).rounded()))%")
                .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
            ForEach(Array(RoadmapStageID.allCases.enumerated()), id: \.element.rawValue) { index, stage in
                let items = store.roadmap.filter { $0.mission.stage == stage }
                let completed = items.allSatisfy { store.completedIDs.contains($0.id) }
                Label("\(index + 1). \(stage.rawValue.capitalized)", systemImage: completed ? "checkmark.circle.fill" : items.contains { store.isUnlocked($0.mission) } ? "circle.fill" : "lock.fill")
                    .font(AppTypography.title3.bold()).foregroundStyle(completed ? Color.appSuccess : Color.appTextPrimary)
                VStack(spacing: 0) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { offset, item in
                        NavigationLink { MissionActivityView(store: store, item: item) } label: {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: store.completedIDs.contains(item.id) ? "checkmark.circle.fill" : store.isUnlocked(item.mission) ? "circle.fill" : "lock.fill")
                                    .foregroundStyle(store.completedIDs.contains(item.id) ? Color.appSuccess : store.isUnlocked(item.mission) ? Color.appInfo : Color.appTextTertiary)
                                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                    Text(item.mission.title).font(AppTypography.body).foregroundStyle(Color.appTextPrimary)
                                    Text(store.completedIDs.contains(item.id) ? "Completed" : store.isUnlocked(item.mission) ? item.classification.rawValue : "Complete prerequisites first")
                                        .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                                }
                                Spacer(minLength: 0); Image(systemName: "chevron.right").font(AppTypography.caption).foregroundStyle(Color.appTextTertiary)
                            }.padding(.vertical, AppSpacing.md)
                        }.buttonStyle(.plain)
                        if offset < items.count - 1 { Divider().padding(.leading, 30) }
                    }
                }.padding(.horizontal, AppSpacing.lg).journeyCard()
            }
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Label("Your skill snapshot", systemImage: "chart.bar").font(AppTypography.headline)
                NavigationLink("View skill breakdown & history") { SkillHistoryView(store: store) }.frame(minHeight: 44)
                Text("Mission completion records your work. Reassessment updates your proficiency scores.").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
            }.padding(AppSpacing.lg).journeyCard()
        } else {
            HStack(spacing: AppSpacing.lg) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("You chose").foregroundStyle(Color.appTextSecondary)
                    Text(store.activeDomain.title).font(AppTypography.title.bold())
                    Label("Goal Confirmed", systemImage: "checkmark.circle").font(AppTypography.subheadline.bold()).foregroundStyle(Color.appSuccess)
                }
                Spacer(minLength: 0)
                Group {
                    if store.activeDomain == .productManagement { Image("productManager").resizable().scaledToFit().frame(width: 112).accessibilityHidden(true) }
                    else { JourneyIcon(name: JourneyAppearance.icon(store.activeDomain), color: JourneyAppearance.color(store.activeDomain), size: 80) }
                }
            }.padding(AppSpacing.xl).journeyCard()
            Text("Build your starting point").font(AppTypography.title2.bold())
            HStack(spacing: AppSpacing.md) {
                JourneyIcon(name: "checklist")
                VStack(alignment: .leading, spacing: AppSpacing.xs) { Text("\(store.activeDomain.shortTitle) Skill Check").font(AppTypography.headline); Text("Eight skills. Capability and evidence. A roadmap based on your answers.").foregroundStyle(Color.appTextSecondary) }
            }
            AppButton(title: "Assess my \(store.activeDomain.shortTitle) skills", action: { assessment = true }, systemImage: "arrow.right")
            Text("What you’ll build").font(AppTypography.title2.bold())
            curriculum
        }
        if store.latestSkillSession != nil {
            AppButton(title: "Reassess my \(store.activeDomain.shortTitle) skills", action: { assessment = true }, systemImage: "checklist")
        }
    }
    private var curriculum: some View {
        VStack(spacing: 0) {
            ForEach(Array(store.missions.prefix(3).enumerated()), id: \.element.id) { index, mission in
                HStack(spacing: AppSpacing.md) {
                    JourneyIcon(name: ["briefcase", "scope", "triangle"][index], size: 40)
                    VStack(alignment: .leading, spacing: AppSpacing.xxs) { Text(mission.title).font(AppTypography.headline); Text(mission.evidence).font(AppTypography.caption).foregroundStyle(Color.appTextSecondary) }
                    Spacer(minLength: 0)
                }.padding(.vertical, AppSpacing.md)
                if index < 2 { Divider() }
            }
        }.padding(.horizontal, AppSpacing.lg).journeyCard()
    }
}

struct MissionActivityView: View {
    @Bindable var store: JourneyStore
    let item: MissionPlan
    @State private var evidence = ""
    @State private var reflection = ""
    @State private var saved = false
    @State private var undo = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Text(item.mission.title).font(AppTypography.largeTitle.bold())
                Text("\(item.mission.stage.rawValue.capitalized) · \(item.classification.rawValue)").foregroundStyle(Color.appTextSecondary)
                section("Why this matters", item.mission.why)
                Image(item.mission.domainID == .productManagement && item.mission.stage == .portfolio ? "productManager" : "Assessment").resizable().scaledToFit().frame(maxWidth: .infinity).frame(height: 110).accessibilityHidden(true)
                section("Activity", item.classification == .validation
                    ? "Use an existing artifact that demonstrates this mission’s objective. Check it against the evidence requirements below, ask a peer for one piece of feedback, and record what the artifact proves and what remains untested. You do not need to repeat a full project."
                    : item.mission.activity)
                section("Evidence to create", item.mission.evidence)
                if let address = item.mission.resourceURL, let url = URL(string: address), url.scheme == "https", let title = item.mission.resourceTitle {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Link(destination: url) { Label(title, systemImage: "arrow.up.right.square") }.frame(minHeight: 44)
                        Text("Optional further reading. Opens in your browser and requires internet. All mission instructions are available offline.").font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                    }.padding(AppSpacing.lg).journeyCard()
                }
                section("Reflection prompt", item.mission.reflection)
                if !store.isUnlocked(item.mission) {
                    section("Before you start", item.mission.prerequisiteMissionIDs.compactMap { id in store.missions.first { $0.id == id }?.title }.joined(separator: "\n"))
                }
                Text("Your Evidence").font(AppTypography.title3.bold())
                Text("Describe what you made and where you keep it. Avoid personal or sensitive details; CareerZ stores these notes locally and does not verify external artifacts.")
                    .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                TextField("Artifact description or link", text: $evidence, axis: .vertical).lineLimit(3...8)
                    .padding(AppSpacing.md).cardBackground().accessibilityLabel("Mission evidence")
                Text("Your reflection").font(AppTypography.headline)
                TextField("What did you learn?", text: $reflection, axis: .vertical).lineLimit(3...8)
                    .padding(AppSpacing.md).cardBackground().accessibilityLabel("Mission reflection")
                Button("Save notes without completing") { saved = store.saveMission(item.mission, evidence: evidence, reflection: reflection, complete: store.completedIDs.contains(item.id)) }
                    .frame(minHeight: 44)
                if let date = store.evidence(for: item.id)?.completedAt {
                    Text("Completed \(date.formatted(date: .abbreviated, time: .shortened))").font(AppTypography.footnote)
                    Button("Undo completion", role: .destructive) { undo = true }.frame(minHeight: 44)
                } else {
                    AppButton(title: "Complete this mission", action: { saved = store.saveMission(item.mission, evidence: evidence, reflection: reflection, complete: true) }, systemImage: "checkmark", isEnabled: store.isUnlocked(item.mission) && !evidence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                if saved { Label("Saved on this device", systemImage: "checkmark.circle").foregroundStyle(Color.appSuccess) }
                Text("Notes are saved when you tap a save button. Completion is your declaration of evidence, not a certification.")
                    .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
            }.padding(AppSpacing.screenHorizontal)
        }.scrollDismissesKeyboard(.interactively).background(Color.appGroupedBackground).navigationBarTitleDisplayMode(.inline)
        .onAppear { evidence = store.evidence(for: item.id)?.evidence ?? ""; reflection = store.evidence(for: item.id)?.reflection ?? "" }
        .onChange(of: evidence) { _, _ in saved = false }
        .onChange(of: reflection) { _, _ in saved = false }
        .alert("Undo this completion?", isPresented: $undo) {
            Button("Undo completion", role: .destructive) { saved = store.saveMission(item.mission, evidence: evidence, reflection: reflection, complete: false) }
            Button("Cancel", role: .cancel) {}
        } message: { Text("Your evidence and reflection will be kept. Completed dependent missions must be undone first.") }
    }
    private func section(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Label(title, systemImage: title == "Activity" ? "hammer" : title == "Evidence to create" ? "doc.text" : title == "Reflection prompt" ? "bubble.left" : "lightbulb")
                .font(AppTypography.headline).foregroundStyle(Color.appPrimary)
            Text(text).foregroundStyle(Color.appTextSecondary)
        }.frame(maxWidth: .infinity, alignment: .leading).padding(AppSpacing.lg).journeyCard()
    }
}
