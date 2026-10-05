import Foundation

struct SkillLevelDescriptor: Codable, Equatable, Sendable {
    let level: SkillLevel
    let text: String
}

struct SkillDefinition: Identifiable, Codable, Equatable, Sendable {
    let id: String
    let domainID: CareerDomainID
    let title: String
    let summary: String
    let importanceWeight: Double
    let portfolioTarget: Double
    let levelDescriptors: [SkillLevelDescriptor]
    let evidenceExamples: [String]

    func descriptor(for level: SkillLevel) -> String? {
        levelDescriptors.first(where: { $0.level == level })?.text
    }
}
