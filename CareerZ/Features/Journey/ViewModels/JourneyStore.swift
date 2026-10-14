import Foundation
import Observation
import SwiftData

@MainActor @Observable final class JourneyStore {
    private let context: ModelContext
    private let bundle: Bundle
    var questions: [CompassQuestion] = []
    var skills: [SkillDefinition] = []
    var missions: [JourneyMission] = []
    var compassHistory: [CompassSnapshot] = []
    var skillHistory: [SkillSessionSnapshot] = []
    var evidenceRecords: [MissionEvidenceRecord] = []
    var selectedDomain: CareerDomainID?
    var errorMessage: String?
    var isLoaded = false
    var latestSkillSession: SkillSessionSnapshot? { skillHistory.first }
    var completedIDs: Set<String> { Set(evidenceRecords.filter { $0.completedAt != nil }.map(\.missionID)) }
    var progress: Double { JourneyEngine().progress(missionIDs: Set(missions.map(\.id)), completedIDs: completedIDs) }
    var priorityGaps: [SkillGapResult] {
        guard let latestSkillSession else { return [] }
        return Array(SkillAssessmentEngine().rankedGaps(skills: skills, results: latestSkillSession.results).filter { !$0.meetsTarget }.prefix(3))
    }
    var roadmap: [MissionPlan] = []

    init(context: ModelContext, bundle: Bundle = .main) { self.context = context; self.bundle = bundle; context.autosaveEnabled = false }

    func reload() {
        do {
            let loader = LocalJSONLoader(bundle: bundle)
            let questions = try loader.decode([CompassQuestion].self, from: "compass_questions")
            let skills = try loader.decode([SkillDefinition].self, from: "product_management_skills")
            let missions = try loader.decode([JourneyMission].self, from: "product_management_missions")
            guard Set(questions.map(\.id)).count == questions.count,
                  Set(skills.map(\.id)).count == skills.count else { throw JourneyValidationError.invalidContent }
            // Validate content before letting a user invest time in an assessment.
            _ = try CompassEngine().assess(questions: questions, answers: Dictionary(uniqueKeysWithValues: questions.map { ($0.id, 3) }))
            _ = try JourneyEngine().assess(skills: skills, answers: Dictionary(uniqueKeysWithValues: skills.map { ($0.id, SkillResponse(capability: 0, evidence: 0)) }))
            let records = try context.fetch(FetchDescriptor<AssessmentRecord>(sortBy: [SortDescriptor(\.date, order: .reverse)]))
            let decoder = JSONDecoder()
            let compass = try records.filter { $0.kind == "compass" }.map { try decoder.decode(CompassSnapshot.self, from: $0.payload) }
            let history = try records.filter { $0.kind == "skills" }.map { try decoder.decode(SkillSessionSnapshot.self, from: $0.payload) }
            guard records.allSatisfy({ ["compass", "skills"].contains($0.kind) }), compass.allSatisfy({ $0.contentVersion == 1 }), history.allSatisfy({ $0.contentVersion == 1 && $0.domain == .productManagement }) else {
                throw JourneyValidationError.invalidContent
            }
            let direction = try context.fetch(FetchDescriptor<DirectionRecord>()).first
            if let direction, CareerDomainID(rawValue: direction.domainID) == nil { throw JourneyValidationError.invalidContent }
            self.questions = questions; self.skills = skills; self.missions = missions
            self.compassHistory = compass; self.skillHistory = history
            evidenceRecords = try context.fetch(FetchDescriptor<MissionEvidenceRecord>())
            selectedDomain = direction.flatMap { CareerDomainID(rawValue: $0.domainID) }
            roadmap = try JourneyEngine().roadmap(missions: missions, skills: skills, results: history.first?.results ?? [])
            isLoaded = true
            errorMessage = nil
        } catch { isLoaded = false; errorMessage = error.localizedDescription }
    }

    func choose(_ domain: CareerDomainID) -> Bool {
        transact {
            if let record = try context.fetch(FetchDescriptor<DirectionRecord>()).first { record.domainID = domain.rawValue }
            else { context.insert(DirectionRecord(domainID: domain.rawValue)) }
        }
    }

    func saveCompass(_ answers: [String: Int]) -> Bool {
        transact {
            let result = try CompassEngine().assess(questions: questions, answers: answers)
            context.insert(AssessmentRecord(kind: "compass", date: result.assessedAt, payload: try JSONEncoder().encode(result)))
        }
    }

    func saveSkills(_ answers: [String: SkillResponse]) -> Bool {
        transact {
            let result = try JourneyEngine().assess(skills: skills, answers: answers)
            context.insert(AssessmentRecord(kind: "skills", date: result.assessedAt, payload: try JSONEncoder().encode(result)))
        }
    }

    func evidence(for missionID: String) -> MissionEvidenceRecord? { evidenceRecords.first { $0.missionID == missionID } }
    func isUnlocked(_ mission: JourneyMission) -> Bool { Set(mission.prerequisiteMissionIDs).isSubset(of: completedIDs) }

    func saveMission(_ mission: JourneyMission, evidence: String, reflection: String, complete: Bool) -> Bool {
        transact {
            if complete {
                guard isUnlocked(mission) else { throw StoreError.lockedMission }
                guard !evidence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      !reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw StoreError.missingEvidence }
            }
            if !complete && completedIDs.contains(mission.id) && missions.contains(where: { $0.prerequisiteMissionIDs.contains(mission.id) && completedIDs.contains($0.id) }) {
                throw StoreError.completedDependents
            }
            let record = self.evidence(for: mission.id) ?? MissionEvidenceRecord(missionID: mission.id, evidence: "", reflection: "", completedAt: nil)
            if self.evidence(for: mission.id) == nil { context.insert(record) }
            record.evidence = evidence; record.reflection = reflection
            record.completedAt = complete ? (record.completedAt ?? Date()) : nil
        }
    }

    enum ResetKind: String, Identifiable { case assessments, progress, all; var id: String { rawValue } }
    func reset(_ kind: ResetKind) -> Bool {
        transact {
            if kind == .assessments || kind == .all {
                for record in try context.fetch(FetchDescriptor<AssessmentRecord>()) { context.delete(record) }
            }
            if kind == .progress || kind == .all {
                for record in try context.fetch(FetchDescriptor<MissionEvidenceRecord>()) { context.delete(record) }
            }
            if kind == .all {
                for record in try context.fetch(FetchDescriptor<DirectionRecord>()) { context.delete(record) }
            }
        }
    }

    private func transact(_ operation: () throws -> Void) -> Bool {
        do { try operation(); try context.save(); reload(); return isLoaded }
        catch { context.rollback(); errorMessage = error.localizedDescription; return false }
    }
    private enum StoreError: LocalizedError {
        case lockedMission, missingEvidence, completedDependents
        var errorDescription: String? {
            switch self {
            case .lockedMission: "Complete the prerequisite missions first."
            case .missingEvidence: "Add a description of your evidence and a reflection before completing this mission."
            case .completedDependents: "Undo dependent missions first, or reset all roadmap progress in Settings. Your evidence is kept when you undo a mission."
            }
        }
    }
}
