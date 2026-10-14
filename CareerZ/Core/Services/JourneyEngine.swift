import Foundation

struct JourneyEngine: Sendable {
    func assess(skills: [SkillDefinition], answers: [String: SkillResponse], at date: Date = Date()) throws -> SkillSessionSnapshot {
        guard !skills.isEmpty, Set(skills.map(\.id)).count == skills.count,
              skills.allSatisfy({ $0.domainID == .productManagement && $0.importanceWeight > 0 && $0.importanceWeight.isFinite && $0.portfolioTarget.isFinite && (0...4).contains($0.portfolioTarget) }),
              abs(skills.reduce(0) { $0 + $1.importanceWeight } - 1) < 0.00001 else {
            throw JourneyValidationError.invalidContent
        }
        guard Set(answers.keys) == Set(skills.map(\.id)) else { throw JourneyValidationError.incompleteAnswers }
        guard answers.values.allSatisfy({ (0...4).contains($0.capability) && (0...4).contains($0.evidence) }) else {
            throw JourneyValidationError.invalidAnswer
        }
        let engine = SkillAssessmentEngine()
        let results = skills.map { skill in
            let answer = answers[skill.id]!
            return engine.assess(skill: skill, capabilityLevel: answer.capability, evidenceLevel: answer.evidence, assessedAt: date)
        }
        return SkillSessionSnapshot(contentVersion: 1, domain: .productManagement, assessedAt: date, results: results)
    }

    func roadmap(missions: [JourneyMission], skills: [SkillDefinition], results: [SkillAssessmentResult]) throws -> [MissionPlan] {
        let skillIDs = Set(skills.map(\.id))
        guard !missions.isEmpty, Set(missions.map(\.id)).count == missions.count,
              missions.allSatisfy({ $0.domainID == .productManagement && skillIDs.contains($0.primarySkillID) && Set($0.supportingSkillIDs).isSubset(of: skillIDs) }) else {
            throw JourneyValidationError.invalidContent
        }
        let gaps = SkillAssessmentEngine().rankedGaps(skills: skills, results: results)
        let byID = Dictionary(uniqueKeysWithValues: gaps.map { ($0.id, $0) })
        var remaining = missions
        var emitted = Set<String>()
        var plan: [MissionPlan] = []
        // Topological sort prevents high-priority missions jumping prerequisites.
        while !remaining.isEmpty {
            let available = remaining.filter { Set($0.prerequisiteMissionIDs).isSubset(of: emitted) }
            guard let mission = available.sorted(by: {
                let lhs = byID[$0.primarySkillID]?.priorityScore ?? 0
                let rhs = byID[$1.primarySkillID]?.priorityScore ?? 0
                if lhs == rhs { return $0.id < $1.id }
                return lhs > rhs
            }).first else { throw JourneyValidationError.invalidContent }
            let gap = byID[mission.primarySkillID]!
            let classification: MissionClassification = gap.meetsTarget ? .validation : (mission.prerequisiteMissionIDs.isEmpty ? .core : .recommended)
            plan.append(MissionPlan(mission: mission, classification: classification, priority: gap.priorityScore))
            emitted.insert(mission.id)
            remaining.removeAll { $0.id == mission.id }
        }
        return plan
    }

    func recommendation(for gap: SkillGapResult) -> String {
        if gap.currentScore < 1 { return "Start with the fundamentals of \(gap.skill.title.lowercased()). Pick one concept and explain it using a real product." }
        if gap.currentScore < 2.5 { return "Practice \(gap.skill.title.lowercased()) with a small project. Keep an artifact that someone else can review." }
        return "Strengthen your evidence for \(gap.skill.title.lowercased()). Ask for feedback and document your decisions and limits."
    }

    func progress(missionIDs: Set<String>, completedIDs: Set<String>) -> Double {
        guard !missionIDs.isEmpty else { return 0 }
        return Double(missionIDs.intersection(completedIDs).count) / Double(missionIDs.count)
    }
}
