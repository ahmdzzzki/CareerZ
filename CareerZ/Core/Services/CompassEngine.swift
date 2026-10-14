import Foundation

struct CompassEngine: Sendable {
    // Trait order is explicit rather than depending on dictionary iteration.
    static let weights: [CareerDomainID: [Double]] = [
        .softwareEngineering: [25, 25, 5, 5, 5, 5, 25, 5],
        .mobileDevelopment: [20, 20, 10, 20, 5, 10, 10, 5],
        .productDesign: [10, 5, 20, 25, 15, 15, 5, 5],
        .productManagement: [15, 5, 10, 5, 20, 20, 10, 15],
        .dataAnalytics: [15, 10, 5, 5, 10, 5, 40, 10],
        .artificialIntelligence: [20, 25, 10, 5, 5, 5, 25, 5]
    ]

    func assess(questions: [CompassQuestion], answers: [String: Int], at date: Date = Date()) throws -> CompassSnapshot {
        guard questions.count == 40,
              Set(questions.map(\.id)).count == questions.count,
              CompassTrait.allCases.allSatisfy({ trait in questions.filter { $0.trait == trait }.count == 5 }) else {
            throw JourneyValidationError.invalidContent
        }
        guard Set(answers.keys) == Set(questions.map(\.id)) else {
            throw JourneyValidationError.incompleteAnswers
        }
        guard answers.values.allSatisfy({ (1...5).contains($0) }) else {
            throw JourneyValidationError.invalidAnswer
        }
        let traitScores = CompassTrait.allCases.map { trait in
            let items = questions.filter { $0.trait == trait }
            let total = items.reduce(0) { sum, item in
                let answer = answers[item.id]!
                return sum + (item.reversed ? 6 - answer : answer)
            }
            return (Double(total) / 5 - 1) / 4 * 100
        }
        let matches = CareerDomainID.allCases.map { domain in
            let weights = Self.weights[domain]!
            let contributions = CompassTrait.allCases.enumerated().map { index, trait in
                CompassContribution(trait: trait, score: traitScores[index], contribution: traitScores[index] * weights[index] / 100)
            }.sorted {
                if $0.contribution == $1.contribution { return $0.trait.rawValue < $1.trait.rawValue }
                return $0.contribution > $1.contribution
            }
            return CompassMatch(domain: domain, score: contributions.reduce(0) { $0 + $1.contribution }, contributions: contributions)
        }.sorted {
            if $0.score == $1.score { return $0.domain.rawValue < $1.domain.rawValue }
            return $0.score > $1.score
        }
        return CompassSnapshot(contentVersion: 1, assessedAt: date, answers: answers, matches: matches)
    }
}
