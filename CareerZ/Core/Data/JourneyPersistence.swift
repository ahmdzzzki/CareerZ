import Foundation
import SwiftData

// Explicit version 1 schema: future model changes must add a migration stage.
enum JourneySchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [AssessmentRecord.self, MissionEvidenceRecord.self, DirectionRecord.self] }

    @Model final class AssessmentRecord {
        @Attribute(.unique) var id: UUID
        var kind: String
        var date: Date
        var payload: Data
        init(kind: String, date: Date, payload: Data) {
            id = UUID(); self.kind = kind; self.date = date; self.payload = payload
        }
    }
    @Model final class MissionEvidenceRecord {
        @Attribute(.unique) var missionID: String
        var evidence: String
        var reflection: String
        var completedAt: Date?
        init(missionID: String, evidence: String, reflection: String, completedAt: Date?) {
            self.missionID = missionID; self.evidence = evidence
            self.reflection = reflection; self.completedAt = completedAt
        }
    }
    @Model final class DirectionRecord {
        @Attribute(.unique) var id: String
        var domainID: String
        init(domainID: String) { id = "selected-direction"; self.domainID = domainID }
    }
}

enum JourneySchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] { [AssessmentRecord.self, MissionEvidenceRecord.self, DirectionRecord.self] }

    @Model final class AssessmentRecord {
        var id: UUID = UUID()
        var kind: String = ""
        var date: Date = Date()
        var payload: Data = Data()
        init(kind: String, date: Date, payload: Data) {
            id = UUID(); self.kind = kind; self.date = date; self.payload = payload
        }
    }
    @Model final class MissionEvidenceRecord {
        var missionID: String = ""
        var updatedAt: Date = Date()
        var evidence: String = ""
        var reflection: String = ""
        var completedAt: Date? = nil
        init(missionID: String, evidence: String, reflection: String, completedAt: Date?) {
            self.missionID = missionID; self.evidence = evidence
            self.reflection = reflection; self.completedAt = completedAt
        }
    }
    @Model final class DirectionRecord {
        var id: String = "selected-direction"
        var updatedAt: Date = Date()
        var domainID: String = ""
        init(domainID: String) { id = "selected-direction"; self.domainID = domainID }
    }
}

enum JourneyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [JourneySchemaV1.self, JourneySchemaV2.self] }
    static var stages: [MigrationStage] { [.lightweight(fromVersion: JourneySchemaV1.self, toVersion: JourneySchemaV2.self)] }
}

typealias AssessmentRecord = JourneySchemaV2.AssessmentRecord
typealias MissionEvidenceRecord = JourneySchemaV2.MissionEvidenceRecord
typealias DirectionRecord = JourneySchemaV2.DirectionRecord
