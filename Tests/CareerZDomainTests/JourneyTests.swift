import XCTest
@testable import CareerZDomain

final class JourneyTests: XCTestCase {
    let loader = LocalJSONLoader(bundle: .module)
    func questions() throws -> [CompassQuestion] { try loader.decode([CompassQuestion].self, from: "compass_questions") }
    func skills() throws -> [SkillDefinition] { try loader.decode([SkillDefinition].self, from: "product_management_skills") }
    func missions() throws -> [JourneyMission] { try loader.decode([JourneyMission].self, from: "product_management_missions") }

    func testCompassContentAndWeightsCoverAllDomains() throws {
        let items = try questions()
        XCTAssertEqual(items.count, 40)
        XCTAssertEqual(Set(items.map(\.id)).count, 40)
        for trait in CompassTrait.allCases {
            XCTAssertEqual(items.filter { $0.trait == trait }.count, 5)
            XCTAssertTrue(items.contains { $0.trait == trait && $0.reversed })
        }
        XCTAssertEqual(Set(CompassEngine.weights.keys), Set(CareerDomainID.allCases))
        for weights in CompassEngine.weights.values {
            XCTAssertEqual(weights.count, 8)
            XCTAssertEqual(weights.reduce(0, +), 100)
        }
    }

    func testCompassNormalizationAndReverseScoring() throws {
        let items = try questions()
        let date = Date(timeIntervalSince1970: 123)
        for expected in [0.0, 50, 100] {
            let value = Int(expected / 25) + 1
            let answers = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0.reversed ? 6 - value : value) })
            let result = try CompassEngine().assess(questions: items, answers: answers, at: date)
            XCTAssertEqual(result.assessedAt, date)
            XCTAssertEqual(result.matches.count, 6)
            XCTAssertTrue(result.hasCloseLeaders)
            for match in result.matches { XCTAssertEqual(match.score, expected, accuracy: 0.0001) }
        }
    }

    func testCompassRejectsIncompleteAndOutOfRangeAnswers() throws {
        let items = try questions()
        XCTAssertThrowsError(try CompassEngine().assess(questions: items, answers: [:]))
        let answers = Dictionary(uniqueKeysWithValues: items.map { ($0.id, 6) })
        XCTAssertThrowsError(try CompassEngine().assess(questions: items, answers: answers))
    }

    func testCompassExplanationMatchesItsActualWeightedContributions() throws {
        let items = try questions()
        let answers = Dictionary(uniqueKeysWithValues: items.map { item in
            let level = [.communication, .empathy, .ownership].contains(item.trait) ? 5 : 1
            return (item.id, item.reversed ? 6 - level : level)
        })
        let first = try CompassEngine().assess(questions: items, answers: answers).matches.first!
        XCTAssertEqual(first.domain, .productManagement)
        XCTAssertEqual(first.score, 55, accuracy: 0.0001)
        XCTAssertEqual(Set(first.contributions.prefix(3).map(\.trait)), [.communication, .empathy, .ownership])
    }

    func testSkillScoreClampAndGap() {
        let engine = SkillAssessmentEngine()
        XCTAssertEqual(engine.calculateScore(capabilityLevel: 3, evidenceLevel: 2), 2.6, accuracy: 0.0001)
        XCTAssertEqual(engine.calculateScore(capabilityLevel: -10, evidenceLevel: 20), 1.6, accuracy: 0.0001)
        XCTAssertEqual(engine.calculateGap(currentScore: 4, portfolioTarget: 3), 0)
        XCTAssertEqual(engine.calculatePriority(gap: -1, importanceWeight: 0.15), 0)
    }

    func testCompleteSkillSessionAndTaxonomyIntegrity() throws {
        let items = try skills()
        XCTAssertEqual(items.count, 8)
        XCTAssertEqual(items.reduce(0) { $0 + $1.importanceWeight }, 1, accuracy: 0.0001)
        for skill in items { XCTAssertEqual(Set(skill.levelDescriptors.map { $0.level.rawValue }), Set(0...4)) }
        let answers = Dictionary(uniqueKeysWithValues: items.map { ($0.id, SkillResponse(capability: 3, evidence: 2)) })
        let snapshot = try JourneyEngine().assess(skills: items, answers: answers)
        XCTAssertEqual(snapshot.results.count, 8)
        for result in snapshot.results { XCTAssertEqual(result.calculatedScore, 2.6, accuracy: 0.0001) }
        XCTAssertEqual(try JSONDecoder().decode(SkillSessionSnapshot.self, from: JSONEncoder().encode(snapshot)), snapshot)
    }

    func testSkillAssessmentCannotSilentlySavePartialOrInvalidData() throws {
        XCTAssertThrowsError(try JourneyEngine().assess(skills: skills(), answers: [:]))
        let answers = Dictionary(uniqueKeysWithValues: try skills().map { ($0.id, SkillResponse(capability: 5, evidence: 0)) })
        XCTAssertThrowsError(try JourneyEngine().assess(skills: skills(), answers: answers))
    }

    func testRepeatedSkillResultsUseLatestInsteadOfCrashing() throws {
        let skill = try skills()[0]
        let engine = SkillAssessmentEngine()
        let old = engine.assess(skill: skill, capabilityLevel: 0, evidenceLevel: 0, assessedAt: Date(timeIntervalSince1970: 1))
        let new = engine.assess(skill: skill, capabilityLevel: 4, evidenceLevel: 4, assessedAt: Date(timeIntervalSince1970: 2))
        for results in [[old, new], [new, old]] {
            let gap = engine.rankedGaps(skills: [skill], results: results)[0]
            XCTAssertEqual(gap.currentScore, 4)
            XCTAssertEqual(gap.gap, 0)
        }
    }

    func testRoadmapPreservesPrerequisitesAndNeverAutoCompletes() throws {
        let items = try skills()
        let answers = Dictionary(uniqueKeysWithValues: items.map { ($0.id, SkillResponse(capability: 4, evidence: 4)) })
        let session = try JourneyEngine().assess(skills: items, answers: answers)
        let plan = try JourneyEngine().roadmap(missions: missions(), skills: items, results: session.results)
        XCTAssertEqual(plan.count, 10)
        var seen = Set<String>()
        for item in plan {
            XCTAssertTrue(Set(item.mission.prerequisiteMissionIDs).isSubset(of: seen))
            XCTAssertEqual(item.classification, .validation)
            seen.insert(item.id)
        }
        XCTAssertEqual(JourneyEngine().progress(missionIDs: seen, completedIDs: []), 0)
        XCTAssertEqual(JourneyEngine().progress(missionIDs: seen, completedIDs: Set(plan.prefix(5).map(\.id))), 0.5)
        XCTAssertEqual(JourneyEngine().progress(missionIDs: [], completedIDs: ["unrelated"]), 0)
    }

    func testRoadmapRejectsMissingPrerequisite() throws {
        let mission = JourneyMission(id: "bad", domainID: .productManagement, stage: .foundation, title: "Bad", primarySkillID: try skills()[0].id, supportingSkillIDs: [], prerequisiteMissionIDs: ["missing"], why: "", activity: "", evidence: "", reflection: "")
        XCTAssertThrowsError(try JourneyEngine().roadmap(missions: [mission], skills: skills(), results: []))
    }
}

extension JourneyTests {
    func testHistoryOrderingAndFirstAssessmentHasNoInventedDelta() throws {
        let skill = try skills()[0]
        let engine = SkillAssessmentEngine()
        let early = SkillSessionSnapshot(contentVersion: 1, domain: .productManagement, assessedAt: Date(timeIntervalSince1970: 1), results: [engine.assess(skill: skill, capabilityLevel: 1, evidenceLevel: 1)])
        let later = SkillSessionSnapshot(contentVersion: 1, domain: .productManagement, assessedAt: Date(timeIntervalSince1970: 2), results: [engine.assess(skill: skill, capabilityLevel: 3, evidenceLevel: 3)])
        let service = SkillHistoryService()
        XCTAssertNil(service.change(for: skill.id, in: []))
        XCTAssertNil(service.change(for: skill.id, in: [early]))
        XCTAssertEqual(service.ordered([early, later]).first, later)
        XCTAssertEqual(service.change(for: skill.id, in: [early, later])!, 2, accuracy: 0.0001)
    }
    func testPriorityRankingIsDescendingAndRecommendationsFollowProficiency() throws {
        let items = try skills()
        let gaps = SkillAssessmentEngine().rankedGaps(skills: items, results: [])
        XCTAssertEqual(gaps.map(\.priorityScore), gaps.map(\.priorityScore).sorted(by: >))
        for (score, phrase) in [(0.0, "fundamentals"), (1.0, "Practice"), (2.5, "Strengthen")] {
            let gap = SkillGapResult(skill: items[0], currentScore: score, gap: 1, priorityScore: 0.15)
            XCTAssertTrue(JourneyEngine().recommendation(for: gap).contains(phrase))
        }
    }
}


extension JourneyTests {
    func testDashboardProficiencyUsesWeightsAndRejectsMissingSkills() throws {
        let items = try skills()
        let answers = Dictionary(uniqueKeysWithValues: items.enumerated().map {
            ($0.element.id, SkillResponse(capability: $0.offset % 5, evidence: 2))
        })
        let session = try JourneyEngine().assess(skills: items, answers: answers)
        let expected = items.reduce(0.0) { total, skill in
            total + session.results.first { $0.skillID == skill.id }!.calculatedScore * skill.importanceWeight
        }
        XCTAssertEqual(try XCTUnwrap(SkillHistoryService().weightedProficiency(skills: items, session: session)), expected, accuracy: 0.0001)
        XCTAssertNil(SkillHistoryService().weightedProficiency(skills: Array(items.dropLast()), session: session))
        XCTAssertNil(SkillHistoryService().weightedProficiency(skills: [], session: session))
    }
}
