import SwiftUI
import CoreData
import Combine

struct JourneyRootView: View {
    @Bindable var store: JourneyStore
    @AppStorage("hasCompletedOnboarding") private var onboarded = false
    @State private var selectedTab = 0
    @Environment(\.scenePhase) private var phase
    var body: some View {
        Group {
            if !store.isLoaded {
                ContentUnavailableView {
                    Label("Your journey couldn’t be loaded", systemImage: "exclamationmark.triangle")
                } description: { Text(store.errorMessage ?? "Please try again.") }
                actions: { Button("Try again") { store.reload() } }
            } else if !onboarded {
                JourneyWelcomeView { onboarded = true }
            } else {
                TabView(selection: $selectedTab) {
                    JourneyDashboardView(store: store, onDiscover: { selectedTab = 1 }, onRoadmap: { selectedTab = 2 })
                        .tabItem { Label("Home", systemImage: "house.fill") }.tag(0)
                    DiscoveryView(store: store, onDevelop: { selectedTab = 2 })
                        .tabItem { Label("Discover", systemImage: "safari") }.tag(1)
                    DevelopmentView(store: store)
                        .tabItem { Label("Roadmap", systemImage: "map.fill") }.tag(2)
                    JourneySettingsView(store: store, onDelete: { onboarded = false; selectedTab = 0 })
                        .tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(3)
                }
            }
        }
        .tint(.appPrimary)
        .onChange(of: phase) { _, value in if value == .active { store.reload() } }
        .onReceive(NotificationCenter.default.publisher(for: NSPersistentCloudKitContainer.eventChangedNotification).receive(on: RunLoop.main)) { note in
            guard let event = note.userInfo?[NSPersistentCloudKitContainer.eventNotificationUserInfoKey] as? NSPersistentCloudKitContainer.Event else { return }
            if event.endDate == nil { CloudSyncMonitor.shared.detail = "Syncing with iCloud…" }
            else if !event.succeeded { CloudSyncMonitor.shared.detail = "Sync is paused. Your changes are saved locally; iCloud will retry when available." }
            else {
                CloudSyncMonitor.shared.detail = "Last iCloud activity: \(event.endDate!.formatted(date: .abbreviated, time: .shortened))"
                if event.type == .import { store.reload() }
            }
        }
        .alert("Couldn’t complete that action", isPresented: Binding(get: { store.isLoaded && store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
            Button("OK") { store.errorMessage = nil }
        } message: { Text(store.errorMessage ?? "Please try again.") }
    }
}

struct JourneyWelcomeView: View {
    let onStart: () -> Void
    var body: some View {
        OnboardingIntroView(onGetStarted: onStart)
    }
}

enum JourneyCopy {
    static let disclaimer = "CareerZ provides self-assessment and career exploration guidance for personal development. Results are not a psychological diagnosis, professional certification, or guarantee of employment."
    static func experiment(_ domain: CareerDomainID) -> String {
        switch domain {
        case .softwareEngineering: "Build a small tool that solves a recurring problem. Explain your design and test a failure case."
        case .mobileDevelopment: "Sketch and prototype a useful mobile interaction. Test whether someone can use it without instructions."
        case .productDesign: "Observe a confusing experience, sketch an alternative, and ask someone to try it."
        case .productManagement: "Identify a real problem, interview potential users, and propose a measurable outcome."
        case .dataAnalytics: "Choose a question, explore a small public dataset, and communicate an insight with its limits."
        case .artificialIntelligence: "Compare a simple rule-based baseline with a small model experiment and explain its limitations."
        }
    }
}
