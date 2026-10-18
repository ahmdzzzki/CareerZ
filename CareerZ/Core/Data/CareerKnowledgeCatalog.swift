import Foundation

struct CareerKnowledge: Sendable {
    let domain: CareerDomainID
    let skills: [SkillDefinition]
    let missions: [JourneyMission]
}

struct CareerKnowledgeCatalog {
    let bundle: Bundle
    func load() throws -> [CareerDomainID: CareerKnowledge] {
        let loader = LocalJSONLoader(bundle: bundle)
        var catalog: [CareerDomainID: CareerKnowledge] = [:]
        var identifiers = Set<String>()
        for domain in CareerDomainID.allCases {
            let skills = try loader.decode([SkillDefinition].self, from: "\(domain.rawValue)_skills")
            let missions = try loader.decode([JourneyMission].self, from: "\(domain.rawValue)_missions")
            guard skills.count == 8, missions.count == 10,
                  skills.allSatisfy({ $0.domainID == domain && Set($0.levelDescriptors.map(\.level.rawValue)) == Set(0...4) && $0.levelDescriptors.count == 5 && !$0.summary.isEmpty && !$0.evidenceExamples.isEmpty }),
                  missions.allSatisfy({ $0.domainID == domain && !$0.activity.isEmpty && !$0.evidence.isEmpty && !$0.reflection.isEmpty }),
                  Set(missions.map(\.stage)) == Set(RoadmapStageID.allCases) else { throw JourneyValidationError.invalidContent }
            for id in skills.map(\.id) + missions.map(\.id) {
                guard identifiers.insert(id).inserted else { throw JourneyValidationError.invalidContent }
            }
            _ = try JourneyEngine().assess(skills: skills, answers: Dictionary(uniqueKeysWithValues: skills.map { ($0.id, SkillResponse(capability: 0, evidence: 0)) }))
            _ = try JourneyEngine().roadmap(missions: missions, skills: skills, results: [])
            catalog[domain] = CareerKnowledge(domain: domain, skills: skills, missions: missions)
        }
        return catalog
    }
}
