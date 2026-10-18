import SwiftUI
import Charts

struct SkillHistoryView: View {
    @Bindable var store: JourneyStore
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Text("Your Skill Snapshot").font(AppTypography.title.bold())
                Text("Capability contributes 60%; evidence contributes 40%. Scores remain on a 0–4 proficiency scale. The portfolio target is a practice goal, not a hiring threshold.")
                    .foregroundStyle(Color.appTextSecondary)
                if let latest = store.latestSkillSession {
                    if store.skillHistory.count == 1 {
                        Text("Your first skill assessment. This is your baseline—there is no trend to show yet.")
                            .padding(AppSpacing.lg).journeyCard()
                    }
                    VStack(spacing: AppSpacing.lg) {
                        JourneyRing(progress: SkillHistoryService().weightedProficiency(skills: store.skills, session: latest).map { $0 / 4 }, size: 176)
                        Text("Self-assessed proficiency").font(AppTypography.title3.bold())
                        Text("Your weighted skill score, shown as a percentage of the 0–4 scale.").font(AppTypography.footnote).multilineTextAlignment(.center).foregroundStyle(Color.appTextSecondary)
                    }.frame(maxWidth: .infinity).padding(AppSpacing.xl).journeyCard()
                    if store.skillHistory.count > 1 {
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Your progress over time").font(AppTypography.headline)
                            Chart {
                                ForEach(Array(store.skillHistory.reversed().enumerated()), id: \.offset) { index, snapshot in
                                    if let score = SkillHistoryService().weightedProficiency(skills: store.skills, session: snapshot) {
                                        LineMark(x: .value("Assessment", index + 1), y: .value("Proficiency", score)).foregroundStyle(Color.appPrimary)
                                        PointMark(x: .value("Assessment", index + 1), y: .value("Proficiency", score)).foregroundStyle(Color.appPrimary)
                                    }
                                }
                            }.chartYScale(domain: 0...4).frame(height: 160).accessibilityLabel("Weighted proficiency across your stored assessments, on a zero to four scale")
                        }.padding(AppSpacing.lg).journeyCard()
                    }
                    Text("Score Breakdown").font(AppTypography.title2.bold())
                    ForEach(store.skills) { skill in
                        if let result = latest.results.first(where: { $0.skillID == skill.id }) {
                            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                HStack(spacing: AppSpacing.md) { JourneyIcon(name: JourneyAppearance.skillIcon(skill.title)); Text(skill.title).font(AppTypography.headline) }
                                Text("\(result.calculatedScore.formatted(.number.precision(.fractionLength(1)))) / 4 · target \(skill.portfolioTarget.formatted(.number.precision(.fractionLength(0))))")
                                ProgressView(value: result.calculatedScore, total: 4).accessibilityLabel(skill.title)
                                Text("Capability \(result.capabilityLevel) · Evidence \(result.evidenceLevel)")
                                    .font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                                if let delta = SkillHistoryService().change(for: skill.id, in: store.skillHistory) {
                                    Text("\(delta >= 0 ? "+" : "")\(delta.formatted(.number.precision(.fractionLength(1)))) proficiency points since the previous assessment")
                                        .font(AppTypography.footnote)
                                }
                            }.padding(AppSpacing.lg).journeyCard()
                        }
                    }
                }
                if store.latestSkillSession == nil {
                    VStack(spacing: AppSpacing.lg) {
                        Image("Assessment").resizable().scaledToFit().frame(height: 130).accessibilityHidden(true)
                        Text("Your starting point is waiting").font(AppTypography.title2.bold())
                        Text("Complete your selected career assessment from Home or Roadmap. Your scores, focus areas, and history will appear here.").multilineTextAlignment(.center).foregroundStyle(Color.appTextSecondary)
                    }.frame(maxWidth: .infinity).padding(AppSpacing.xl).journeyCard()
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
                                    }.padding(AppSpacing.lg).journeyCard()
                                }
                            }.padding(AppSpacing.screenHorizontal)
                        }.background(Color.appGroupedBackground).navigationTitle("Past assessment")
                    } label: {
                        HStack { Text(snapshot.assessedAt.formatted(date: .abbreviated, time: .shortened)); Spacer(); Image(systemName: "chevron.right") }
                            .padding(AppSpacing.lg).journeyCard()
                    }
                }
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground).navigationTitle("Skills & history").navigationBarTitleDisplayMode(.inline)
    }
}
