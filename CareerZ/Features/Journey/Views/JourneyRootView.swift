import SwiftUI

struct JourneyRootView: View {
    @Bindable var store: JourneyStore
    @AppStorage("hasCompletedOnboarding") private var onboarded = false
    @State private var selectedTab = 0
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
                    DiscoveryView(store: store, onDevelop: { selectedTab = 1 })
                        .tabItem { Label("Discover", systemImage: "safari") }.tag(0)
                    DevelopmentView(store: store)
                        .tabItem { Label("Develop", systemImage: "map") }.tag(1)
                    JourneySettingsView(store: store, onDelete: { onboarded = false; selectedTab = 0 })
                        .tabItem { Label("Profile", systemImage: "person.crop.circle") }.tag(2)
                }
            }
        }
        .tint(.appPrimary)
        .alert("Couldn’t complete that action", isPresented: Binding(get: { store.isLoaded && store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
            Button("OK") { store.errorMessage = nil }
        } message: { Text(store.errorMessage ?? "Please try again.") }
    }
}

struct JourneyWelcomeView: View {
    let onStart: () -> Void
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {
                Image("LogoCareerZWarna").resizable().scaledToFit().frame(width: 64, height: 64).accessibilityHidden(true)
                Text("Many possibilities.\nA direction worth exploring.").font(AppTypography.largeTitle.bold())
                Text("Start with your interests and strengths. Choose a direction, build evidence, and learn from the progress you actually make.")
                    .foregroundStyle(Color.appTextSecondary)
                ForEach([("safari", "Discover", "Compass helps you explore six technology career directions."), ("arrow.up.right", "Decide", "A suggestion is a starting point. You choose your direction."), ("map", "Develop", "The first complete development journey focuses on Product Management.")], id: \.1) { icon, title, detail in
                    Label { VStack(alignment: .leading, spacing: AppSpacing.xs) { Text(title).font(AppTypography.headline); Text(detail).foregroundStyle(Color.appTextSecondary) } }
                    icon: { Image(systemName: icon).foregroundStyle(Color.appPrimary) }
                }
                Text("Your answers and progress stay on this device. No account, cloud sync, or tracking.").font(AppTypography.footnote)
                Text(JourneyCopy.disclaimer).font(AppTypography.footnote).foregroundStyle(Color.appTextSecondary)
                AppButton(title: "Start exploring", action: onStart, systemImage: "arrow.right")
            }.padding(AppSpacing.screenHorizontal)
        }.background(Color.appGroupedBackground)
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
