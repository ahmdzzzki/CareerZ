//
//  RoadmapMilestone.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// A milestone within a stage, e.g. "User Research" under the
/// "Intermediate" stage. Carries its own lessons and detail content
/// for RoadmapDetailView; the overview list only needs id/title/status.
struct RoadmapMilestone: Identifiable, Hashable {
    let id: String
    let title: String
    let status: ProgressStatus
    /// Shown in the overview's "Recommended Next Step" estimate, and
    /// reused as the detail header's estimated time when detail is nil.
    let estimatedMinutes: Int

    /// Detail-screen content. Optional so milestones not yet fleshed
    /// out (e.g. locked, future stages) don't block the overview list
    /// from rendering.
    let detail: RoadmapMilestoneDetail?

    static func == (lhs: RoadmapMilestone, rhs: RoadmapMilestone) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct RoadmapMilestoneDetail {
    let description: String
    let systemImage: String
    let impact: String          // e.g. "High"
    let estimatedTimeLabel: String  // e.g. "4-6 hours"
    let lessons: [RoadmapLesson]
    let whatYoullLearn: [String]
}
