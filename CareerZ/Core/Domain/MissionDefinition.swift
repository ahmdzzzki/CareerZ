import Foundation

enum RoadmapStageID: String, Codable, CaseIterable, Sendable {
    case foundation
    case practice
    case portfolio
}

struct MissionDefinition: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let domainID: CareerDomainID
    let stage: RoadmapStageID
    let title: String
    let primarySkillID: String
    let supportingSkillIDs: [String]
    let prerequisiteMissionIDs: [String]
    let completionEvidence: String
}
