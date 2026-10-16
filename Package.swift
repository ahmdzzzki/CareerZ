// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CareerZDomain",
    platforms: [.macOS(.v14)],
    products: [.library(name: "CareerZDomain", targets: ["CareerZDomain"])],
    targets: [
        .target(
            name: "CareerZDomain", path: "CareerZ",
            exclude: ["App", "Core/Apple", "CareerZ.entitlements", "Features/Assessment", "Features/Home", "Features/Onboarding", "Features/Profile", "Features/Roadmap", "Features/Journey/Views", "Features/Journey/Components", "Navigation", "Core/Components", "Core/Models", "Core/Theme", "Resources/ContentView.swift", "Resources/Assets.xcassets", "Resources/PrivacyInfo.xcprivacy"],
            sources: ["Core/Domain", "Core/Services", "Core/Data", "Features/Journey/ViewModels"],
            resources: [.copy("Resources/CareerKnowledge")]
        ),
        .testTarget(name: "CareerZDomainTests", dependencies: ["CareerZDomain"], path: "Tests/CareerZDomainTests")
    ],
    swiftLanguageModes: [.v5]
)
