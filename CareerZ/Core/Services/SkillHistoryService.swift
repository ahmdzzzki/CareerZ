import Foundation

struct SkillHistoryService: Sendable {
    func weightedProficiency(skills: [SkillDefinition], session: SkillSessionSnapshot) -> Double? {
        guard !skills.isEmpty, Set(skills.map(\.id)).count == skills.count,
              Set(session.results.map(\.skillID)).count == session.results.count,
              Set(skills.map(\.id)) == Set(session.results.map(\.skillID)),
              skills.allSatisfy({ $0.domainID == session.domain && $0.importanceWeight.isFinite && $0.importanceWeight > 0 }),
              abs(skills.reduce(0) { $0 + $1.importanceWeight } - 1) < 0.00001,
              session.results.allSatisfy({ $0.calculatedScore.isFinite && (0...4).contains($0.calculatedScore) }) else { return nil }
        let scores = Dictionary(uniqueKeysWithValues: session.results.map { ($0.skillID, $0.calculatedScore) })
        return skills.reduce(0) { $0 + scores[$1.id]! * $1.importanceWeight }
    }
    func ordered(_ history: [SkillSessionSnapshot]) -> [SkillSessionSnapshot] {
        history.sorted { $0.assessedAt > $1.assessedAt }
    }
    func change(for skillID: String, in history: [SkillSessionSnapshot]) -> Double? {
        let sessions = ordered(history)
        guard sessions.count > 1, sessions[0].contentVersion == sessions[1].contentVersion,
              sessions[0].domain == sessions[1].domain,
              let current = sessions[0].results.first(where: { $0.skillID == skillID }),
              let previous = sessions[1].results.first(where: { $0.skillID == skillID }) else { return nil }
        return current.calculatedScore - previous.calculatedScore
    }
}
