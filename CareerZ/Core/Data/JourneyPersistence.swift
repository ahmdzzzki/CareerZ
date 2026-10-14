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

enum JourneyMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [JourneySchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}

typealias AssessmentRecord = JourneySchemaV1.AssessmentRecord
typealias MissionEvidenceRecord = JourneySchemaV1.MissionEvidenceRecord
typealias DirectionRecord = JourneySchemaV1.DirectionRecord
