import XCTest
import SwiftData
@testable import CareerZDomain

final class PersistenceTests: XCTestCase {
    @MainActor private func container(url: URL) throws -> ModelContainer {
        let schema = Schema(versionedSchema: JourneySchemaV1.self)
        return try ModelContainer(for: schema, migrationPlan: JourneyMigrationPlan.self, configurations: [ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)])
    }
    @MainActor private func answers(_ store: JourneyStore, level: Int) -> [String: SkillResponse] {
        Dictionary(uniqueKeysWithValues: store.skills.map { ($0.id, SkillResponse(capability: level, evidence: level)) })
    }
    @MainActor func testSavedAssessmentsEvidenceAndDirectionSurviveReopeningStore() async throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-\(UUID()).sqlite")
        let first = try container(url: url)
        let store = JourneyStore(context: ModelContext(first), bundle: .module)
        store.reload(); XCTAssertTrue(store.isLoaded, store.errorMessage ?? "")
        XCTAssertNil(store.latestSkillSession)
        XCTAssertTrue(store.choose(.productManagement))
        XCTAssertTrue(store.saveSkills(answers(store, level: 1)))
        XCTAssertEqual(store.skillHistory.count, 1)
        XCTAssertNil(SkillHistoryService().change(for: store.skills[0].id, in: store.skillHistory))
        XCTAssertTrue(store.saveMission(store.missions[0], evidence: "A role comparison", reflection: "I clarified the difference in responsibilities", complete: true))
        let completionDate = store.evidence(for: store.missions[0].id)?.completedAt
        XCTAssertTrue(store.saveSkills(answers(store, level: 3)))
        let reopened = try container(url: url)
        let recovered = JourneyStore(context: ModelContext(reopened), bundle: .module)
        recovered.reload()
        XCTAssertTrue(recovered.isLoaded, recovered.errorMessage ?? "")
        XCTAssertEqual(recovered.selectedDomain, .productManagement)
        XCTAssertEqual(recovered.skillHistory.count, 2)
        XCTAssertEqual(recovered.evidence(for: store.missions[0].id)?.evidence, "A role comparison")
        XCTAssertEqual(recovered.evidence(for: store.missions[0].id)?.completedAt, completionDate)
        XCTAssertEqual(recovered.progress, 0.1, accuracy: 0.0001)
        XCTAssertEqual(SkillHistoryService().change(for: store.skills[0].id, in: recovered.skillHistory)!, 2, accuracy: 0.0001)
    }
    @MainActor func testInvalidCompletionAndPartialAssessmentDoNotChangePersistentProgress() async throws {
        let db = try container(url: FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-\(UUID()).sqlite"))
        let store = JourneyStore(context: ModelContext(db), bundle: .module)
        store.reload()
        XCTAssertFalse(store.saveSkills([:]))
        XCTAssertTrue(store.skillHistory.isEmpty)
        XCTAssertFalse(store.saveMission(store.missions[0], evidence: " ", reflection: " ", complete: true))
        XCTAssertFalse(store.saveMission(store.missions[1], evidence: "A problem statement", reflection: "A reflection", complete: true))
        XCTAssertEqual(store.progress, 0)
        XCTAssertTrue(store.evidenceRecords.isEmpty)
    }
    @MainActor func testUndoKeepsEvidenceAndPreservesPrerequisiteIntegrity() async throws {
        let db = try container(url: FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-\(UUID()).sqlite"))
        let store = JourneyStore(context: ModelContext(db), bundle: .module)
        store.reload()
        for mission in store.missions.prefix(2) {
            XCTAssertTrue(store.saveMission(mission, evidence: "Artifact", reflection: "Reflection", complete: true))
        }
        XCTAssertFalse(store.saveMission(store.missions[0], evidence: "Artifact", reflection: "Reflection", complete: false))
        XCTAssertEqual(store.progress, 0.2, accuracy: 0.0001)
        XCTAssertTrue(store.saveMission(store.missions[1], evidence: "Artifact", reflection: "Reflection", complete: false))
        XCTAssertTrue(store.saveMission(store.missions[0], evidence: "Artifact", reflection: "Reflection", complete: false))
        XCTAssertEqual(store.progress, 0)
        XCTAssertEqual(store.evidenceRecords.count, 2)
        XCTAssertEqual(store.evidence(for: store.missions[0].id)?.evidence, "Artifact")
    }
    @MainActor func testTargetedResetsAndDeleteAll() async throws {
        let db = try container(url: FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-\(UUID()).sqlite"))
        let store = JourneyStore(context: ModelContext(db), bundle: .module)
        store.reload()
        XCTAssertTrue(store.choose(.productManagement))
        let compassAnswers = Dictionary(uniqueKeysWithValues: store.questions.map { ($0.id, 3) })
        XCTAssertTrue(store.saveCompass(compassAnswers))
        XCTAssertTrue(store.saveSkills(answers(store, level: 2)))
        XCTAssertTrue(store.saveMission(store.missions[0], evidence: "Artifact", reflection: "Reflection", complete: true))
        XCTAssertTrue(store.reset(.assessments))
        XCTAssertTrue(store.skillHistory.isEmpty); XCTAssertTrue(store.compassHistory.isEmpty)
        XCTAssertEqual(store.progress, 0.1, accuracy: 0.0001)
        XCTAssertEqual(store.selectedDomain, .productManagement)
        XCTAssertTrue(store.saveSkills(answers(store, level: 2)))
        XCTAssertTrue(store.reset(.progress))
        XCTAssertEqual(store.skillHistory.count, 1)
        XCTAssertTrue(store.evidenceRecords.isEmpty)
        XCTAssertTrue(store.reset(.all))
        XCTAssertNil(store.selectedDomain); XCTAssertTrue(store.skillHistory.isEmpty)
        XCTAssertTrue(store.evidenceRecords.isEmpty)
    }
    @MainActor func testFocusAreasUseWeightedGapsAndLimitToThree() async throws {
        let db = try container(url: FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-\(UUID()).sqlite"))
        let store = JourneyStore(context: ModelContext(db), bundle: .module)
        store.reload()
        let levels = ["User Discovery": 0, "Prioritization": 1, "Product Strategy": 0, "Product Thinking & Problem Framing": 2]
        let answers = Dictionary(uniqueKeysWithValues: store.skills.map { skill in
            let level = levels[skill.title] ?? 3
            return (skill.id, SkillResponse(capability: level, evidence: level))
        })
        XCTAssertTrue(store.saveSkills(answers))
        XCTAssertEqual(store.priorityGaps.map { $0.skill.title }, ["User Discovery", "Prioritization", "Product Strategy"])
        XCTAssertEqual(store.priorityGaps[0].priorityScore, 0.45, accuracy: 0.0001)
        XCTAssertEqual(store.priorityGaps[1].priorityScore, 0.30, accuracy: 0.0001)
        XCTAssertEqual(store.priorityGaps[2].priorityScore, 0.20, accuracy: 0.0001)
    }

}
