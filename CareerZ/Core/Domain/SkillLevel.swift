import Foundation

enum SkillLevel: Int, Codable, CaseIterable, Sendable {
    case notExposed = 0
    case understands = 1
    case guidedPractice = 2
    case independentPractice = 3
    case provenInContext = 4

    var title: String {
        switch self {
        case .notExposed: "Not Yet Exposed"
        case .understands: "Understands"
        case .guidedPractice: "Guided Practice"
        case .independentPractice: "Independent Practice"
        case .provenInContext: "Proven in Context"
        }
    }
}
