//
//  RoadmapLesson.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// A single lesson within a milestone, e.g. "Introduction to User
/// Research" under the "User Research" milestone.
struct RoadmapLesson: Identifiable, Hashable {
    let id: String
    let title: String
    let durationMinutes: Int
    let status: ProgressStatus

    static func == (lhs: RoadmapLesson, rhs: RoadmapLesson) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
