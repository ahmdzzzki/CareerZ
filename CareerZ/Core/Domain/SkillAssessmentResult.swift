import Foundation

struct SkillAssessmentResult: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let skillID: String
    let capabilityLevel: Int
    let evidenceLevel: Int
    let calculatedScore: Double
    let assessedAt: Date

    init(
        id: UUID = UUID(),
        skillID: String,
        capabilityLevel: Int,
        evidenceLevel: Int,
        calculatedScore: Double,
        assessedAt: Date = Date()
    ) {
        self.id = id
        self.skillID = skillID
        self.capabilityLevel = capabilityLevel
        self.evidenceLevel = evidenceLevel
        self.calculatedScore = calculatedScore
        self.assessedAt = assessedAt
    }
}

struct SkillGapResult: Identifiable, Equatable, Sendable {
    let skill: SkillDefinition
    let currentScore: Double
    let gap: Double
    let priorityScore: Double

    var id: String { skill.id }
    var meetsTarget: Bool { gap == 0 }
}
