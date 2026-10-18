import Foundation

enum CareerDomainID: String, Codable, CaseIterable, Identifiable, Sendable {
    case softwareEngineering = "software_engineering"
    case mobileDevelopment = "mobile_development"
    case productDesign = "product_design"
    case productManagement = "product_management"
    case dataAnalytics = "data_analytics"
    case artificialIntelligence = "artificial_intelligence"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .softwareEngineering: "Software Engineering"
        case .mobileDevelopment: "Mobile Development"
        case .productDesign: "Product Design"
        case .productManagement: "Product Management"
        case .dataAnalytics: "Data & Analytics"
        case .artificialIntelligence: "AI & Machine Learning"
        }
    }
}


extension CareerDomainID {
    var shortTitle: String {
        switch self {
        case .softwareEngineering: "Software"
        case .mobileDevelopment: "Mobile"
        case .productDesign: "Design"
        case .productManagement: "PM"
        case .dataAnalytics: "Data"
        case .artificialIntelligence: "AI & ML"
        }
    }
    var roadmapTitle: String { self == .productManagement ? "Product Manager Roadmap" : "\(title) Roadmap" }
}
