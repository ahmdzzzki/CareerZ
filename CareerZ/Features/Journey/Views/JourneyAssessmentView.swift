import SwiftUI

struct JourneyAssessmentView: View {
    enum Kind { case compass, skills }
    @Bindable var store: JourneyStore
    let kind: Kind
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var assessmentDomain: CareerDomainID?
    @State private var evidencePhase = false
    @State private var compassAnswers: [String: Int] = [:]
    @State private var capabilityAnswers: [String: Int] = [:]
    @State private var evidenceAnswers: [String: Int] = [:]
    @State private var discard = false
    @State private var failure: String?
    private var count: Int { kind == .compass ? store.questions.count : store.skills.count }
    private var ready: Bool {
        if kind == .compass { return compassAnswers[store.questions[index].id] != nil }
        let id = store.skills[index].id
        return evidencePhase ? evidenceAnswers[id] != nil : capabilityAnswers[id] != nil
    }
    private let likert = ["Not like me at all", "Slightly unlike me", "Sometimes like me", "Quite like me", "Very much like me"]
    private let evidenceLabels = ["No evidence or experience", "Learning notes or conceptual understanding", "A guided exercise or project", "An independent, reviewable project artifact", "A real-context artifact with feedback or outcome"]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    HStack {
                        Text("Question \(kind == .compass ? index + 1 : index * 2 + (evidencePhase ? 2 : 1)) of \(kind == .compass ? count : count * 2)").font(AppTypography.headline)
                        Spacer()
                        Text("\(Int(Double(kind == .compass ? compassAnswers.count : capabilityAnswers.count + evidenceAnswers.count) / Double(kind == .compass ? count : count * 2) * 100))% answered")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                    }
                    ProgressView(value: Double(kind == .compass ? compassAnswers.count : capabilityAnswers.count + evidenceAnswers.count), total: Double(kind == .compass ? count : count * 2)).tint(.appPrimary).accessibilityLabel("Answered questions")
                    if kind == .compass {
                        let question = store.questions[index]
                        Text(question.text).font(AppTypography.title2.bold())
                        Text("Choose the answer that feels most like you. There is no preferred answer.")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        ForEach(1...5, id: \.self) { value in
                            option(likert[value - 1], selected: compassAnswers[question.id] == value) { compassAnswers[question.id] = value }
                        }
                    } else {
                        let skill = store.skills[index]
                        Text(skill.title).font(AppTypography.title3.bold())
                        Text(skill.summary).foregroundStyle(Color.appTextSecondary)
                        Text(evidencePhase ? "What evidence can you show?" : "How do you apply this skill?").font(AppTypography.headline).foregroundStyle(Color.appPrimary)
                        if evidencePhase {
                            Text("Examples: \(skill.evidenceExamples.joined(separator: ", ")).").font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                            ForEach(0...4, id: \.self) { value in
                                option("\(value) · \(evidenceLabels[value])", selected: evidenceAnswers[skill.id] == value) { evidenceAnswers[skill.id] = value }
                            }
                        } else {
                            ForEach(SkillLevel.allCases, id: \.rawValue) { level in
                                option("\(level.rawValue) · \(level.title)\n\(skill.descriptor(for: level) ?? "")", selected: capabilityAnswers[skill.id] == level.rawValue) {
                                    capabilityAnswers[skill.id] = level.rawValue
                                }
                            }
                        }
                    }
                    Text("Answers are saved only when you complete the assessment. You can go back to review your answers.")
                        .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                }.padding(AppSpacing.screenHorizontal)
            }.id("\(index)-\(evidencePhase)").background(Color.appGroupedBackground)
            .navigationTitle(kind == .compass ? "CareerZ Compass" : "\(store.activeDomain.shortTitle) skill assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: goBack) { Image(systemName: "chevron.left").fontWeight(.semibold) }
                        .accessibilityLabel("Back")
                }
                ToolbarItem(placement: .confirmationAction) { Button("Close") { discard = true } }
            }
            .safeAreaInset(edge: .bottom) {
                AppButton(title: index == count - 1 && (kind == .compass || evidencePhase) ? "Save my assessment" : "Continue", action: advance, isEnabled: ready)
                    .padding(.horizontal, AppSpacing.screenHorizontal).padding(.top, AppSpacing.sm).padding(.bottom, AppSpacing.md)
                    .background(Color.appGroupedBackground)
            }
            .interactiveDismissDisabled()
            .onAppear { if assessmentDomain == nil { assessmentDomain = store.activeDomain } }
            .alert("Assessment wasn’t saved", isPresented: Binding(get: { failure != nil }, set: { if !$0 { failure = nil } })) {
                Button("OK") { failure = nil }
            } message: { Text(failure ?? "Please try again.") }
            .alert("Discard these unsaved answers?", isPresented: $discard) {
                Button("Discard answers", role: .destructive) { dismiss() }
                Button("Keep answering", role: .cancel) {}
            }
        }
    }
    private func option(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Text(title).font(AppTypography.body).foregroundStyle(Color.appTextPrimary).multilineTextAlignment(.leading)
                Spacer(minLength: AppSpacing.sm)
                Image(systemName: selected ? "largecircle.fill.circle" : "circle")
                    .font(AppTypography.title2).foregroundStyle(selected ? Color.appPrimary : Color.appSeparator).accessibilityHidden(true)
            }.padding(AppSpacing.lg).frame(maxWidth: .infinity, minHeight: 76, alignment: .leading)
                .background(selected ? Color.appPrimary.opacity(0.10) : Color.appCardBackground, in: RoundedRectangle(cornerRadius: AppRadius.xxl))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.xxl).stroke(selected ? Color.appPrimary : Color.appSeparator.opacity(0.12), lineWidth: selected ? 2 : 1))
        }.buttonStyle(.plain).accessibilityValue(selected ? "Selected" : "Not selected")
    }
    private func goBack() {
        if kind == .skills && evidencePhase { evidencePhase = false }
        else if index > 0 { index -= 1; evidencePhase = kind == .skills }
        else { discard = true }
    }
    private func advance() {
        guard kind == .compass || assessmentDomain == store.activeDomain else {
            failure = "Your career direction changed. Close this assessment and start again for your selected direction."
            return
        }
        if kind == .skills && !evidencePhase { evidencePhase = true; return }
        guard index == count - 1 else { index += 1; evidencePhase = false; return }
        if kind == .compass {
            if store.saveCompass(compassAnswers) { dismiss() } else { failure = store.errorMessage; store.errorMessage = nil }
        } else {
            var answers: [String: SkillResponse] = [:]
            for skill in store.skills {
                if let capability = capabilityAnswers[skill.id], let evidence = evidenceAnswers[skill.id] {
                    answers[skill.id] = SkillResponse(capability: capability, evidence: evidence)
                }
            }
            if store.saveSkills(answers, for: assessmentDomain) { dismiss() } else { failure = store.errorMessage; store.errorMessage = nil }
        }
    }
}
