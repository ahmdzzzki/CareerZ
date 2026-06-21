//
//  NextStep.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

struct NextStep: Identifiable, Hashable {
    let id: String
    /// Actionable phrasing shown on the Home CTA card, e.g.
    /// "Complete PM Assessment".
    let homeCardTitle: String
    /// Plain assessment name shown on the Detail screen header, e.g.
    /// "PM Assessment".
    let title: String
    let description: String
    let systemImage: String
    let readinessDeltaPercent: Int   // e.g. 5 -> "+5% Readiness"
    let estimatedMinutes: Int
    let questionCount: Int
    /// Subjects covered by this assessment, shown as a plain list on
    /// the Next Step Detail screen (e.g. "Agile Methodology").
    let topics: [String]

    static func == (lhs: NextStep, rhs: NextStep) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension NextStep {
    static let sample = NextStep(
        id: "pm-assessment",
        homeCardTitle: "Complete PM Assessment",
        title: "PM Assessment",
        description: "Assess your current product management skills and help us personalize your roadmap.",
        systemImage: "list.clipboard",
        readinessDeltaPercent: 5,
        estimatedMinutes: 10,
        questionCount: 20,
        topics: [
            "Agile Methodology",
            "Product Strategy",
            "Data Literacy",
            "Prioritization",
            "User Research",
        ]
    )
}
