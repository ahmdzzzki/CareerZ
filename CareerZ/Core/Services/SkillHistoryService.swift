import Foundation

struct SkillHistoryService: Sendable {
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
