import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var store: JourneyStore?
    var body: some View {
        Group {
            if let store { JourneyRootView(store: store) }
            else { ProgressView("Opening your career journey…") }
        }
        .task {
            guard store == nil else { return }
            let created = JourneyStore(context: context)
            created.reload()
            store = created
        }
    }
}
