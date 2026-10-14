import SwiftUI

extension View {
    func journeyCard() -> some View { cardBackground(cornerRadius: AppRadius.xxl) }
}

struct JourneyIcon: View {
    let name: String
    var color: Color = .appPrimary
    var size: CGFloat = 48
    var body: some View {
        Image(systemName: name).font(.system(size: size * 0.45, weight: .medium))
            .foregroundStyle(color).frame(width: size, height: size)
            .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: AppRadius.lg))
            .accessibilityHidden(true)
    }
}

struct JourneyRing: View {
    let progress: Double?
    var title = "Self-assessed proficiency"
    var color: Color = .appSuccess
    var size: CGFloat = 114
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        ZStack {
            Circle().stroke(color.opacity(0.13), lineWidth: 12)
            if let progress {
                Circle().trim(from: 0, to: min(max(progress, 0), 1))
                    .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(reduceMotion ? nil : .easeOut(duration: 0.45), value: progress)
            }
            Text(progress.map { "\(Int(($0 * 100).rounded()))%" } ?? "—")
                .font(AppTypography.title.bold()).monospacedDigit()
                .lineLimit(1).minimumScaleFactor(0.35).frame(width: size - 24)
                .foregroundStyle(Color.appTextPrimary)
        }.frame(width: size, height: size)
        .accessibilityElement(children: .ignore).accessibilityLabel(title)
        .accessibilityValue(progress.map { "\(Int(($0 * 100).rounded())) percent" } ?? "Not assessed")
    }
}

enum JourneyAppearance {
    static func icon(_ domain: CareerDomainID) -> String {
        switch domain {
        case .softwareEngineering: "chevron.left.forwardslash.chevron.right"
        case .mobileDevelopment: "iphone"
        case .productDesign: "paintpalette"
        case .productManagement: "briefcase"
        case .dataAnalytics: "chart.xyaxis.line"
        case .artificialIntelligence: "cpu"
        }
    }
    static func color(_ domain: CareerDomainID) -> Color {
        switch domain {
        case .softwareEngineering, .mobileDevelopment: .appInfo
        case .productDesign: .appSuccess
        case .productManagement: .appPrimary
        case .dataAnalytics: .appDanger
        case .artificialIntelligence: .appWarning
        }
    }
    static func subtitle(_ domain: CareerDomainID) -> String {
        switch domain {
        case .softwareEngineering: "Development & Architecture"
        case .mobileDevelopment: "Apps & Platform Experiences"
        case .productDesign: "Visual Design & User Research"
        case .productManagement: "Strategy, Roadmaps & Delivery"
        case .dataAnalytics: "Insights & Decision Making"
        case .artificialIntelligence: "Models, Experiments & Evaluation"
        }
    }
    static func skillIcon(_ title: String) -> String {
        if title.contains("Discovery") { return "person.2" }
        if title.contains("Strategy") { return "scope" }
        if title.contains("Prioritization") { return "list.number" }
        if title.contains("Roadmapping") { return "map" }
        if title.contains("Analytics") { return "chart.bar" }
        if title.contains("Communication") { return "bubble.left.and.bubble.right" }
        if title.contains("Execution") { return "checkmark.circle" }
        return "gearshape"
    }
}
