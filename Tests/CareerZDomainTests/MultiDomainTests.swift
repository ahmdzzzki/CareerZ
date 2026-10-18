import XCTest
import SwiftData
@testable import CareerZDomain

final class MultiDomainTests: XCTestCase {
    func testEveryDomainHasCompleteScorableContentAndReachableRoadmap() throws {
        let catalog = try CareerKnowledgeCatalog(bundle: .module).load()
        XCTAssertEqual(catalog.count, 6)
        for domain in CareerDomainID.allCases {
            let content = try XCTUnwrap(catalog[domain])
            XCTAssertEqual(content.skills.count, 8)
            XCTAssertEqual(content.missions.count, 10)
            XCTAssertEqual(Set(content.missions.flatMap { [$0.primarySkillID] + $0.supportingSkillIDs }), Set(content.skills.map(\.id)), "Every skill needs mission coverage in \(domain)")
            for level in 0...4 {
                let answers = Dictionary(uniqueKeysWithValues: content.skills.map { ($0.id, SkillResponse(capability: level, evidence: level)) })
                let session = try JourneyEngine().assess(skills: content.skills, answers: answers)
                XCTAssertEqual(session.domain, domain)
                XCTAssertEqual(try XCTUnwrap(SkillHistoryService().weightedProficiency(skills: content.skills, session: session)), Double(level), accuracy: 0.0001)
                let plan = try JourneyEngine().roadmap(missions: content.missions, skills: content.skills, results: session.results)
                let stages = plan.map { RoadmapStageID.allCases.firstIndex(of: $0.mission.stage)! }
                XCTAssertEqual(stages, stages.sorted())
                var completed = Set<String>()
                for item in plan {
                    XCTAssertTrue(Set(item.mission.prerequisiteMissionIDs).isSubset(of: completed))
                    completed.insert(item.id)
                    if level == 4 { XCTAssertEqual(item.classification, .validation) }
                }
                XCTAssertEqual(JourneyEngine().progress(missionIDs: completed, completedIDs: completed), 1)
            }
            XCTAssertThrowsError(try JourneyEngine().assess(skills: content.skills, answers: [:]))
            XCTAssertTrue(content.missions.allSatisfy { URL(string: $0.resourceURL ?? "")?.scheme == "https" })
        }
    }

    @MainActor func testAllSixJourneysPersistAndSwitchWithoutSharingScoresOrNotes() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-six-\(UUID()).sqlite")
        let schema = Schema(versionedSchema: JourneySchemaV2.self)
        func open() throws -> ModelContainer {
            try ModelContainer(for: schema, migrationPlan: JourneyMigrationPlan.self, configurations: [ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)])
        }
        let first = try open()
        let store = JourneyStore(context: ModelContext(first), bundle: .module)
        store.reload()
        for (index, domain) in CareerDomainID.allCases.enumerated() {
            XCTAssertTrue(store.choose(domain))
            XCTAssertNil(store.latestSkillSession)
            XCTAssertEqual(store.progress, 0)
            let answers = Dictionary(uniqueKeysWithValues: store.skills.map { ($0.id, SkillResponse(capability: index % 4, evidence: index % 4)) })
            XCTAssertTrue(store.saveSkills(answers), store.errorMessage ?? "")
            for mission in store.roadmap.map(\.mission) {
                XCTAssertTrue(store.saveMission(mission, evidence: "\(domain.rawValue) artifact", reflection: "Reviewed \(domain.title) decision", complete: true), store.errorMessage ?? "")
            }
            XCTAssertEqual(store.progress, 1)
            XCTAssertTrue(store.saveSkills(Dictionary(uniqueKeysWithValues: store.skills.map { ($0.id, SkillResponse(capability: 4, evidence: 4)) })))
            XCTAssertEqual(store.skillHistory.count, 2)
        }
        let second = try open()
        let recovered = JourneyStore(context: ModelContext(second), bundle: .module)
        recovered.reload()
        XCTAssertTrue(recovered.isLoaded, recovered.errorMessage ?? "")
        XCTAssertEqual(recovered.allSkillHistory.count, 12)
        for domain in CareerDomainID.allCases {
            XCTAssertTrue(recovered.choose(domain))
            XCTAssertEqual(recovered.latestSkillSession?.domain, domain)
            XCTAssertEqual(recovered.skillHistory.count, 2)
            XCTAssertEqual(recovered.completedIDs.count, 10)
            XCTAssertTrue(recovered.evidenceRecords.allSatisfy { $0.evidence == "\(domain.rawValue) artifact" })
            XCTAssertTrue(recovered.saveMission(recovered.roadmap.last!.mission, evidence: "Retained", reflection: "Retained", complete: false))
            XCTAssertEqual(recovered.progress, 0.9, accuracy: 0.0001)
        }
        XCTAssertTrue(recovered.reset(.all))
        XCTAssertTrue(recovered.allSkillHistory.isEmpty)
        for domain in CareerDomainID.allCases {
            XCTAssertTrue(recovered.choose(domain))
            XCTAssertNil(recovered.latestSkillSession)
            XCTAssertTrue(recovered.evidenceRecords.isEmpty)
        }
    }

    @MainActor func testDirectionChangeRejectsStaleActionsAndTargetedResetsCoverAllCareers() throws {
        let schema = Schema(versionedSchema: JourneySchemaV2.self)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("CareerZ-reset-\(UUID()).sqlite")
        let db = try ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)])
        let store = JourneyStore(context: ModelContext(db), bundle: .module)
        store.reload()
        XCTAssertTrue(store.choose(.softwareEngineering))
        let oldMission = store.missions[0]
        let oldAnswers = Dictionary(uniqueKeysWithValues: store.skills.map { ($0.id, SkillResponse(capability: 2, evidence: 2)) })
        XCTAssertTrue(store.choose(.mobileDevelopment))
        XCTAssertFalse(store.saveSkills(oldAnswers, for: .softwareEngineering))
        XCTAssertFalse(store.isUnlocked(oldMission))
        XCTAssertFalse(store.saveMission(oldMission, evidence: "Old", reflection: "Old", complete: true))
        XCTAssertTrue(store.allSkillHistory.isEmpty)
        for domain in [CareerDomainID.softwareEngineering, .mobileDevelopment] {
            XCTAssertTrue(store.choose(domain))
            XCTAssertTrue(store.saveSkills(Dictionary(uniqueKeysWithValues: store.skills.map { ($0.id, SkillResponse(capability: 2, evidence: 2)) })))
            XCTAssertTrue(store.saveMission(store.missions[0], evidence: "Artifact", reflection: "Reflection", complete: true))
        }
        XCTAssertTrue(store.reset(.assessments))
        XCTAssertTrue(store.allSkillHistory.isEmpty)
        XCTAssertEqual(store.progress, 0.1, accuracy: 0.0001)
        XCTAssertTrue(store.choose(.softwareEngineering))
        XCTAssertNil(store.latestSkillSession)
        XCTAssertEqual(store.progress, 0.1, accuracy: 0.0001)
        XCTAssertTrue(store.reset(.progress))
        XCTAssertTrue(store.choose(.mobileDevelopment))
        XCTAssertEqual(store.progress, 0)
    }

    func testMixedDomainsAreRejectedBySharedEngine() throws {
        let catalog = try CareerKnowledgeCatalog(bundle: .module).load()
        let software = catalog[.softwareEngineering]!
        let mobile = catalog[.mobileDevelopment]!
        let mixed = Array(software.skills.dropLast()) + [mobile.skills[0]]
        XCTAssertThrowsError(try JourneyEngine().assess(skills: mixed, answers: [:]))
        XCTAssertThrowsError(try JourneyEngine().roadmap(missions: mobile.missions, skills: software.skills, results: []))
    }
}
