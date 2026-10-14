import SwiftUI

struct SkillHistoryView: View {
    @Bindable var store: JourneyStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Text("Your growth, with context.").font(AppTypography.largeTitle.bold())
                Text("Capability contributes 60%; evidence contributes 40%. Scores remain on a 0–4 proficiency scale. The portfolio target is a practice goal, not a hiring threshold.")
                    .foregroundStyle(Color.appTextSecondary)
                if let latest = store.latestSkillSession {
                    if store.skillHistory.count == 1 {
                        Text("Your first skill assessment. This is your baseline—there is no trend to show yet.")
                            .padding(AppSpacing.cardPadding).cardBackground()
                    }
                    ForEach(store.skills) { skill in
                        if let result = latest.results.first(where: { $0.skillID == skill.id }) {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                Text(skill.title).font(AppTypography.headline)
                                Text("\(result.calculatedScore.formatted(.number.precision(.fractionLength(1)))) / 4 · target \(skill.portfolioTarget.formatted(.number.precision(.fractionLength(0))))")
                                ProgressView(value: result.calculatedScore, total: 4).accessibilityLabel(skill.title)
                                Text("Capability \(result.capabilityLevel) · Evidence \(result.evidenceLevel)")
                                    .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                                if let delta = SkillHistoryService().change(for: skill.id, in: store.skillHistory) {
                                    Text("\(delta >= 0 ? "+" : "")\(delta.formatted(.number.precision(.fractionLength(1)))) proficiency points since the previous assessment")
                                        .font(AppTypography.footnote)
                                }
                            }.padding(AppSpacing.cardPadding).cardBackground()
                        }
                    }
                }
                Text("Assessment history").font(AppTypography.title2.bold())
                ForEach(Array(store.skillHistory.enumerated()), id: \.offset) { _, snapshot in
                    NavigationLink {
                        ScrollView {
                            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                                Text(snapshot.assessedAt.formatted(date: .complete, time: .shortened)).font(AppTypography.headline)
                                ForEach(snapshot.results) { result in
                                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                        Text(store.skills.first { $0.id == result.skillID }?.title ?? result.skillID).font(AppTypography.headline)
                                        Text("\(result.calculatedScore.formatted(.number.precision(.fractionLength(1)))) / 4 · capability \(result.capabilityLevel) · evidence \(result.evidenceLevel)")
                                    }.padding(AppSpacing.cardPadding).cardBackground()
                                }
                            }.padding(AppSpacing.screenHorizontal)
                        }.background(Color.appGroupedBackground).navigationTitle("Past assessment")
                    } label: {
                        HStack { Text(snapshot.assessedAt.formatted(date: .abbreviated, time: .shortened)); Spacer(); Image(systemName: "chevron.right") }
                            .padding(AppSpacing.cardPadding).cardBackground()
                    }
                }
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("Skills & history").navigationBarTitleDisplayMode(.inline)
    }
}
