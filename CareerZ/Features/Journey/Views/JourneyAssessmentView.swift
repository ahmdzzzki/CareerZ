import SwiftUI

struct JourneyAssessmentView: View {
    enum Kind { case compass, skills }
    @Bindable var store: JourneyStore
    let kind: Kind
    @Environment(\.dismiss) private var dismiss
    @State private var index = 0
    @State private var compassAnswers: [String: Int] = [:]
    @State private var capabilityAnswers: [String: Int] = [:]
    @State private var evidenceAnswers: [String: Int] = [:]
    @State private var discard = false
    @State private var failure: String?
    private var count: Int { kind == .compass ? store.questions.count : store.skills.count }
    private var ready: Bool {
        if kind == .compass { return compassAnswers[store.questions[index].id] != nil }
        let id = store.skills[index].id
        return capabilityAnswers[id] != nil && evidenceAnswers[id] != nil
    }
    private let likert = ["Not like me at all", "Slightly unlike me", "Sometimes like me", "Quite like me", "Very much like me"]
    private let evidenceLabels = ["No evidence or experience", "Learning notes or conceptual understanding", "A guided exercise or project", "An independent, reviewable project artifact", "A real-context artifact with feedback or outcome"]
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    Text(kind == .compass ? "Think about your usual tendencies." : "Describe what you can do—and what you can show.")
                        .font(AppTypography.title2.bold())
                    Text("\(index + 1) of \(count)").font(AppTypography.subheadline).foregroundStyle(Color.appTextSecondary)
                    ProgressView(value: Double(index + 1), total: Double(count)).accessibilityLabel("Assessment progress")
                    if kind == .compass {
                        let question = store.questions[index]
                        Text(question.text).font(AppTypography.title3.bold())
                        Text("Choose the answer that feels most like you. There is no preferred answer.")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        ForEach(1...5, id: \.self) { value in
                            option(likert[value - 1], selected: compassAnswers[question.id] == value) { compassAnswers[question.id] = value }
                        }
                    } else {
                        let skill = store.skills[index]
                        Text(skill.title).font(AppTypography.title3.bold())
                        Text(skill.summary).foregroundStyle(Color.appTextSecondary)
                        Text("Capability").font(AppTypography.headline)
                        ForEach(SkillLevel.allCases, id: \.rawValue) { level in
                            option("\(level.rawValue) · \(level.title)\n\(skill.descriptor(for: level) ?? "")", selected: capabilityAnswers[skill.id] == level.rawValue) {
                                capabilityAnswers[skill.id] = level.rawValue
                            }
                        }
                        Text("Evidence").font(AppTypography.headline)
                        Text("Examples: \(skill.evidenceExamples.joined(separator: ", ")). Level 4 means proven in a context, not expert.")
                            .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                        ForEach(0...4, id: \.self) { value in
                            option("\(value) · \(evidenceLabels[value])", selected: evidenceAnswers[skill.id] == value) { evidenceAnswers[skill.id] = value }
                        }
                    }
                    AppButton(title: index == count - 1 ? "Save my assessment" : "Continue", action: advance, systemImage: "arrow.right", isEnabled: ready)
                    if index > 0 { Button("Back") { index -= 1 }.frame(minHeight: 44) }
                    Text("Answers are saved only when you complete the assessment. You can go back to review your answers.")
                        .font(AppTypography.caption).foregroundStyle(Color.appTextSecondary)
                }.padding(AppSpacing.screenHorizontal)
            }.id(index).background(Color.appGroupedBackground)
            .navigationTitle(kind == .compass ? "CareerZ Compass" : "PM skill assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { discard = true } } }
            .interactiveDismissDisabled()
            .alert("Assessment wasn’t saved", isPresented: Binding(get: { failure != nil }, set: { if !$0 { failure = nil } })) {
                Button("OK") { failure = nil }
            } message: { Text(failure ?? "Please try again.") }
            .confirmationDialog("Discard these unsaved answers?", isPresented: $discard, titleVisibility: .visible) {
                Button("Discard answers", role: .destructive) { dismiss() }
            }
        }
    }
    private func option(_ title: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: AppSpacing.sm) {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle").foregroundStyle(Color.appPrimary).accessibilityHidden(true)
                Text(title).font(AppTypography.body).foregroundStyle(Color.appTextPrimary).multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }.padding(AppSpacing.md).frame(maxWidth: .infinity, minHeight: 52, alignment: .leading)
                .cardBackground().overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(selected ? Color.appPrimary : .clear, lineWidth: 2))
        }.buttonStyle(.plain).accessibilityValue(selected ? "Selected" : "Not selected")
    }
    private func advance() {
        guard index == count - 1 else { index += 1; return }
        if kind == .compass {
            if store.saveCompass(compassAnswers) { dismiss() } else { failure = store.errorMessage; store.errorMessage = nil }
        } else {
            var answers: [String: SkillResponse] = [:]
            for skill in store.skills {
                if let capability = capabilityAnswers[skill.id], let evidence = evidenceAnswers[skill.id] {
                    answers[skill.id] = SkillResponse(capability: capability, evidence: evidence)
                }
            }
            if store.saveSkills(answers) { dismiss() } else { failure = store.errorMessage; store.errorMessage = nil }
        }
    }
}
