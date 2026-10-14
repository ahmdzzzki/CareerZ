import SwiftUI

struct DevelopmentView: View {
    @Bindable var store: JourneyStore
    @State private var assessment = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    if let domain = store.selectedDomain {
                        Text(domain.title).font(AppTypography.largeTitle.bold())
                        if domain == .productManagement {
                            pmJourney
                        } else {
                            Text("Try a small experiment.").font(AppTypography.title2.bold())
                            Text(JourneyCopy.experiment(domain)).padding(AppSpacing.cardPadding).cardBackground()
                            Text("The skill journey for this direction is still in development. You can explore and compare other directions in Discover; Product Management is the first complete pilot.")
                                .foregroundStyle(Color.appTextSecondary)
                        }
                    } else {
                        ContentUnavailableView("Choose a direction first", systemImage: "safari", description: Text("Take Compass or explore the career directions in Discover. You decide where to start."))
                    }
                }.padding(AppSpacing.screenHorizontal)
            }.background(Color.appGroupedBackground).navigationTitle("Develop")
                .sheet(isPresented: $assessment) { JourneyAssessmentView(store: store, kind: .skills) }
        }
    }
    @ViewBuilder private var pmJourney: some View {
        if let latest = store.latestSkillSession {
            Text("Your skill snapshot").font(AppTypography.title2.bold())
            Text("Assessed \(latest.assessedAt.formatted(date: .abbreviated, time: .omitted)). These are self-reported proficiency levels, not an employability score.")
                .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
            NavigationLink("View skill breakdown & history") { SkillHistoryView(store: store) }.frame(minHeight: 44)
            if store.priorityGaps.isEmpty {
                Text("You meet the current portfolio targets. Validate your evidence with the missions—this does not automatically complete them.")
                    .padding(AppSpacing.cardPadding).cardBackground()
            } else {
                Text("Work on these next").font(AppTypography.headline)
                ForEach(store.priorityGaps) { gap in
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text(gap.skill.title).font(AppTypography.headline)
                        Text("Current \(gap.currentScore.formatted(.number.precision(.fractionLength(1)))) / 4 · Portfolio target \(gap.skill.portfolioTarget.formatted(.number.precision(.fractionLength(0))))")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        Text(JourneyEngine().recommendation(for: gap)).font(AppTypography.callout)
                    }.padding(AppSpacing.cardPadding).cardBackground()
                }
            }
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Your roadmap").font(AppTypography.title2.bold())
                Text("\(store.completedIDs.intersection(Set(store.missions.map(\.id))).count) of \(store.missions.count) missions completed · \(Int((store.progress * 100).rounded()))%")
                ProgressView(value: store.progress).accessibilityLabel("Roadmap completion")
                Text("High scores turn missions into optional validation, not automatic completion. Finish prerequisites to unlock the next activity.")
                    .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
            }
            ForEach(RoadmapStageID.allCases, id: \.rawValue) { stage in
                Text(stage.rawValue.capitalized).font(AppTypography.title3.bold())
                ForEach(store.roadmap.filter { $0.mission.stage == stage }) { item in
                    NavigationLink { MissionActivityView(store: store, item: item) } label: {
                        HStack(alignment: .top, spacing: AppSpacing.sm) {
                            Image(systemName: store.completedIDs.contains(item.id) ? "checkmark.circle.fill" : store.isUnlocked(item.mission) ? "circle" : "lock")
                                .foregroundStyle(Color.appPrimary).accessibilityHidden(true)
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text(item.mission.title).font(AppTypography.headline)
                                Text(store.completedIDs.contains(item.id) ? "Completed" : store.isUnlocked(item.mission) ? item.classification.rawValue : "Complete prerequisites first")
                                    .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                            }
                            Spacer(); Image(systemName: "chevron.right")
                        }.padding(AppSpacing.cardPadding).cardBackground()
                    }
                }
            }
        } else {
            Text("Start with an honest baseline.").font(AppTypography.title2.bold())
            Text("Eight skills. Two answers for each: what you can do and what evidence you have. Your results prioritize the gaps that matter most.")
            Text("No assessment yet. Your roadmap begins after your first skill assessment.")
                .padding(AppSpacing.cardPadding).cardBackground()
        }
        AppButton(title: store.latestSkillSession == nil ? "Assess my PM skills" : "Reassess my PM skills", action: { assessment = true }, systemImage: "checklist")
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
                section("Activity", item.classification == .validation
                    ? "Use an existing artifact that demonstrates this mission’s objective. Check it against the evidence requirements below, ask a peer for one piece of feedback, and record what the artifact proves and what remains untested. You do not need to repeat a full project."
                    : item.mission.activity)
                section("Evidence to create", item.mission.evidence)
                section("Reflection prompt", item.mission.reflection)
                if !store.isUnlocked(item.mission) {
                    section("Before you start", item.mission.prerequisiteMissionIDs.compactMap { id in store.missions.first { $0.id == id }?.title }.joined(separator: "\n"))
                }
                Text("Your evidence").font(AppTypography.headline)
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
        .confirmationDialog("Undo this completion?", isPresented: $undo, titleVisibility: .visible) {
            Button("Undo completion", role: .destructive) { saved = store.saveMission(item.mission, evidence: evidence, reflection: reflection, complete: false) }
        } message: { Text("Your evidence and reflection will be kept. Completed dependent missions must be undone first.") }
    }
    private func section(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) { Text(title).font(AppTypography.headline); Text(text).foregroundStyle(Color.appTextSecondary) }
    }
}
