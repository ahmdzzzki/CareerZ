import Foundation

struct SkillAssessmentEngine: Sendable {
    static let capabilityWeight = 0.60
    static let evidenceWeight = 0.40
    static let validLevelRange = 0...4

    func calculateScore(capabilityLevel: Int, evidenceLevel: Int) -> Double {
        let capability = clamp(capabilityLevel)
        let evidence = clamp(evidenceLevel)

        return (Double(capability) * Self.capabilityWeight)
            + (Double(evidence) * Self.evidenceWeight)
    }

    func calculateGap(currentScore: Double, portfolioTarget: Double) -> Double {
        max(portfolioTarget - currentScore, 0)
    }

    func calculatePriority(gap: Double, importanceWeight: Double) -> Double {
        max(gap, 0) * max(importanceWeight, 0)
    }

    func assess(
        skill: SkillDefinition,
        capabilityLevel: Int,
        evidenceLevel: Int,
        assessedAt: Date = Date()
    ) -> SkillAssessmentResult {
        let score = calculateScore(
            capabilityLevel: capabilityLevel,
            evidenceLevel: evidenceLevel
        )

        return SkillAssessmentResult(
            skillID: skill.id,
            capabilityLevel: clamp(capabilityLevel),
            evidenceLevel: clamp(evidenceLevel),
            calculatedScore: score,
            assessedAt: assessedAt
        )
    }

    func rankedGaps(
        skills: [SkillDefinition],
        results: [SkillAssessmentResult]
    ) -> [SkillGapResult] {
        let resultBySkillID = Dictionary(
            uniqueKeysWithValues: results.map { ($0.skillID, $0) }
        )

        return skills
            .map { skill in
                let currentScore = resultBySkillID[skill.id]?.calculatedScore ?? 0
                let gap = calculateGap(
                    currentScore: currentScore,
                    portfolioTarget: skill.portfolioTarget
                )

                return SkillGapResult(
                    skill: skill,
                    currentScore: currentScore,
                    gap: gap,
                    priorityScore: calculatePriority(
                        gap: gap,
                        importanceWeight: skill.importanceWeight
                    )
                )
            }
            .sorted { lhs, rhs in
                if lhs.priorityScore == rhs.priorityScore {
                    return lhs.skill.title < rhs.skill.title
                }
                return lhs.priorityScore > rhs.priorityScore
            }
    }

    private func clamp(_ level: Int) -> Int {
        min(max(level, Self.validLevelRange.lowerBound), Self.validLevelRange.upperBound)
    }
}
