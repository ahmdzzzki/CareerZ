//
//  ScoreComponent.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// A single contributor to the overall readiness score
/// (e.g. "Assessment Results: 80%"), expandable to show how that
/// sub-score is broken down further.
struct ScoreComponent: Identifiable {
    let id: String
    let title: String
    let percent: Int
    let systemImage: String
    /// Short explanation shown when the row is expanded.
    let detail: String
}

extension ScoreComponent {
    static let sample: [ScoreComponent] = [
        ScoreComponent(
            id: "assessment-results",
            title: "Assessment Results",
            percent: 80,
            systemImage: "doc.text.fill",
            detail: "Based on your latest PM Assessment, covering product strategy, execution, and stakeholder management questions."
        ),
        ScoreComponent(
            id: "skill-progress",
            title: "Skill Progress",
            percent: 20,
            systemImage: "doc.text.fill",
            detail: "Tracks how many roadmap lessons and milestones you've completed so far."
        ),
        ScoreComponent(
            id: "profile-completeness",
            title: "Profile Completeness",
            percent: 28,
            systemImage: "doc.text.fill",
            detail: "How much of your profile — experience, goals, and portfolio links — is filled in."
        ),
        ScoreComponent(
            id: "experience",
            title: "Experience",
            percent: 50,
            systemImage: "doc.text.fill",
            detail: "Derived from your reported work and project experience relevant to your target role."
        ),
    ]
}
