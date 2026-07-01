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
<<<<<<< HEAD
            systemImage: "doc.text.fill",
=======
            systemImage: "checklist",
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            detail: "Based on your latest PM Assessment, covering product strategy, execution, and stakeholder management questions."
        ),
        ScoreComponent(
            id: "skill-progress",
            title: "Skill Progress",
            percent: 20,
<<<<<<< HEAD
            systemImage: "doc.text.fill",
=======
            systemImage: "chart.line.uptrend.xyaxis",
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            detail: "Tracks how many roadmap lessons and milestones you've completed so far."
        ),
        ScoreComponent(
            id: "profile-completeness",
            title: "Profile Completeness",
            percent: 28,
<<<<<<< HEAD
            systemImage: "doc.text.fill",
=======
            systemImage: "person.text.rectangle",
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            detail: "How much of your profile — experience, goals, and portfolio links — is filled in."
        ),
        ScoreComponent(
            id: "experience",
            title: "Experience",
            percent: 50,
<<<<<<< HEAD
            systemImage: "doc.text.fill",
=======
            systemImage: "briefcase",
>>>>>>> 397fad2f163417689b15a3a88e01ef95be9bcd0a
            detail: "Derived from your reported work and project experience relevant to your target role."
        ),
    ]
}
