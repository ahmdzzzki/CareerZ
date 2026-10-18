import SwiftUI

struct JourneySettingsView: View {
    @Bindable var store: JourneyStore
    let onDelete: () -> Void
    @AppStorage("displayName") private var displayName = ""
    @State private var resetKind: JourneyStore.ResetKind?
    @State private var confirmation = false
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: AppSpacing.md) {
                        JourneyIcon(name: "person.crop.circle", size: 64)
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Your Profile").font(AppTypography.title2.bold())
                            TextField("Your name (optional)", text: $displayName).textContentType(.givenName)
                        }
                    }.padding(.vertical, AppSpacing.sm)
                }
                AppleAccountSection()
                Section("Your direction") {
                    Text(store.selectedDomain?.title ?? "No direction selected")
                    Text("Change your direction in Discover. Your previous assessments and mission evidence are retained.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
                Section("On this device") {
                    LabeledContent("Compass assessments", value: "\(store.compassHistory.count)")
                    LabeledContent("Skill assessments (all careers)", value: "\(store.allSkillHistory.count)")
                    LabeledContent("Completed missions (current career)", value: "\(store.completedIDs.count)")
                    Text("Progress is saved on this device and syncs through your private iCloud database on supported signed builds. No tracking or analytics.")
                        .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                }
                Section {
                    NavigationLink("About CareerZ & assessment") { about }
                }
                Section("Manage progress") {
                    Button("Reset assessment history", role: .destructive) { ask(.assessments) }
                    Button("Reset roadmap progress & notes", role: .destructive) { ask(.progress) }
                    Button("Delete all progress", role: .destructive) { ask(.all) }
                }
            }.navigationTitle("Profile")
                .alert(resetTitle, isPresented: $confirmation) {
                    Button("Delete permanently", role: .destructive) {
                        if let kind = resetKind, store.reset(kind), kind == .all { displayName = ""; onDelete() }
                        resetKind = nil
                    }
                    Button("Cancel", role: .cancel) { resetKind = nil }
                } message: { Text(resetMessage) }
        }
    }
    private func ask(_ kind: JourneyStore.ResetKind) { resetKind = kind; confirmation = true }
    private var resetTitle: String {
        switch resetKind {
        case .assessments: "Delete all assessment history?"
        case .progress: "Delete all mission progress and notes?"
        case .all: "Delete all CareerZ progress?"
        case nil: "Manage local data"
        }
    }
    private var resetMessage: String {
        switch resetKind {
        case .assessments: "Compass and skill assessments for every career will be deleted. Direction and mission evidence stay. Take a new skill assessment to generate a new roadmap. This cannot be undone. With iCloud sync, these deletions also apply to your other devices."
        case .progress: "Mission completion, evidence notes, and reflections for every career will be deleted. Assessment history and your direction stay. This cannot be undone. With iCloud sync, these deletions also apply to your other devices."
        case .all: "Assessments, direction, mission notes, and completion will be deleted, and onboarding will restart. Your Apple connection is kept. This cannot be undone. With iCloud sync, these deletions also apply to your other devices."
        case nil: ""
        }
    }
    private var about: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Image("LogoCareerZWarna").resizable().scaledToFit().frame(height: 48).frame(maxWidth: .infinity).accessibilityLabel("CareerZ")
                Text("Discover → Decide → Develop").font(AppTypography.title.bold())
                Text("CareerZ helps students and fresh graduates explore technology career directions and develop skills with practical, reviewable work. All six career domains include a skill assessment and practical roadmap.")
                Text("How Compass works").font(AppTypography.title2.bold())
                Text("40 statements cover eight tendencies. Answers use a 1–5 scale; some questions reverse the scale. Each trait’s average is normalized to 0–100, then weighted differently for six career domains. Top matches show the largest trait contributions. Close matches are treated as options to explore, not a definitive winner.")
                Text("A useful conversation starter—not a validated psychological test. Your answers can change with experience and context. A match is not a probability of success.")
                    .foregroundStyle(Color.appTextSecondary)
                Text("How skill assessment works").font(AppTypography.title2.bold())
                Text("Each skill combines capability × 0.6 and evidence × 0.4 on a 0–4 scale. Gap is max(target − score, 0). Priority is gap × skill importance. Portfolio targets guide practice; they are not employment requirements. Completing a mission requires your own evidence and reflection and does not increase skill scores automatically.")
                Text("Your privacy").font(AppTypography.title2.bold())
                Text("Answers, direction, and mission notes are stored locally with SwiftData and synced privately through Apple iCloud on supported builds. Sign in with Apple is optional. CareerZ uses no advertising or analytics SDK. Resetting synced progress also deletes it from iCloud and other connected devices once sync completes.")
                Text(JourneyCopy.disclaimer).font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                Text("Version \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")")
                    .font(AppTypography.caption)
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("About assessment").navigationBarTitleDisplayMode(.inline)
    }
}
