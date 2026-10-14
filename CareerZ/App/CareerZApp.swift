import SwiftUI
import SwiftData

@main
struct CareerZApp: App {
    private let storage: Result<ModelContainer, Error>
    init() {
        storage = Result {
            let schema = Schema(versionedSchema: JourneySchemaV1.self)
            let configuration = ModelConfiguration(schema: schema, cloudKitDatabase: .none)
            return try ModelContainer(for: schema, migrationPlan: JourneyMigrationPlan.self, configurations: [configuration])
        }
    }
    var body: some Scene {
        WindowGroup {
            switch storage {
            case .success(let container): ContentView().modelContainer(container)
            case .failure:
                ContentUnavailableView {
                    Label("Your local data could not be opened", systemImage: "externaldrive.badge.exclamationmark")
                } description: {
                    Text("CareerZ has not replaced or deleted your data. Restart the app and check available device storage before trying again.")
                }
            }
        }
    }
}
