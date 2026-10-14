import Foundation

enum CompassTrait: String, Codable, CaseIterable, Identifiable, Sendable {
    case problemSolving, technicalCuriosity, creativity, visualThinking
    case communication, empathy, analyticalThinking, ownership
    var id: String { rawValue }
    var title: String {
        switch self {
        case .problemSolving: "Problem Solving"
        case .technicalCuriosity: "Technical Curiosity"
        case .creativity: "Creativity"
        case .visualThinking: "Visual Thinking"
        case .communication: "Communication"
        case .empathy: "Empathy"
        case .analyticalThinking: "Analytical Thinking"
        case .ownership: "Leadership & Ownership"
        }
    }
}

struct CompassQuestion: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let trait: CompassTrait
    let text: String
    let reversed: Bool
}

struct CompassContribution: Codable, Equatable, Identifiable, Sendable {
    let trait: CompassTrait
    let score: Double
    let contribution: Double
    var id: String { trait.rawValue }
}

struct CompassMatch: Codable, Equatable, Identifiable, Sendable {
    let domain: CareerDomainID
    let score: Double
    let contributions: [CompassContribution]
    var id: String { domain.rawValue }
}

struct CompassSnapshot: Codable, Equatable, Sendable {
    let contentVersion: Int
    let assessedAt: Date
    let answers: [String: Int]
    let matches: [CompassMatch]
    var hasCloseLeaders: Bool {
        matches.count > 1 && abs(matches[0].score - matches[1].score) < 5
    }
}

struct SkillResponse: Codable, Equatable, Sendable {
    let capability: Int
    let evidence: Int
}

struct SkillSessionSnapshot: Codable, Equatable, Sendable {
    let contentVersion: Int
    let domain: CareerDomainID
    let assessedAt: Date
    let results: [SkillAssessmentResult]
}

struct JourneyMission: Codable, Equatable, Identifiable, Sendable {
    let id: String
    let domainID: CareerDomainID
    let stage: RoadmapStageID
    let title: String
    let primarySkillID: String
    let supportingSkillIDs: [String]
    let prerequisiteMissionIDs: [String]
    let why: String
    let activity: String
    let evidence: String
    let reflection: String
}

enum MissionClassification: String, Sendable {
    case core = "Core"
    case recommended = "Recommended"
    case validation = "Optional Validation"
}

struct MissionPlan: Identifiable, Sendable {
    let mission: JourneyMission
    let classification: MissionClassification
    let priority: Double
    var id: String { mission.id }
}

enum JourneyValidationError: LocalizedError, Equatable {
    case invalidContent, incompleteAnswers, invalidAnswer
    var errorDescription: String? {
        switch self {
        case .invalidContent: "Career content could not be validated. Please try again or update the app."
        case .incompleteAnswers: "Please answer every question before saving your assessment."
        case .invalidAnswer: "An answer is outside the supported scale. Please review your answers."
        }
    }
}
