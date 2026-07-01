//
//  RoadmapViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class RoadmapViewModel {

    let careerGoal: String
    var stages: [RoadmapStage]

    init(careerGoal: String = "Product Manager", stages: [RoadmapStage] = RoadmapStage.sample) {
        self.careerGoal = careerGoal
        self.stages = stages
    }

    private var allMilestones: [RoadmapMilestone] {
        stages.flatMap(\.milestones)
    }

    var completedMilestones: Int {
        allMilestones.filter { $0.status == .completed }.count
    }

    var totalMilestones: Int {
        allMilestones.count
    }

    /// The stage containing the first non-completed milestone — this
    /// is "where the user currently is" in the roadmap. Falls back to
    /// the last stage if every milestone is somehow already completed.
    var currentStage: String {
        let stage = stages.first { stage in
            stage.milestones.contains { $0.status != .completed }
        } ?? stages.last
        return stage?.title ?? "—"
    }

    /// First in-progress milestone; if none, first locked milestone
    /// (i.e. the very next thing to unlock). Nil only if every
    /// milestone is already completed.
    var nextMilestone: RoadmapMilestone? {
        allMilestones.first { $0.status == .inProgress }
            ?? allMilestones.first { $0.status == .locked }
    }

    var progressText: String {
        "\(completedMilestones) of \(totalMilestones)"
    }

    var progressValue: Double {
        guard totalMilestones > 0 else { return 0 }
        return Double(completedMilestones) / Double(totalMilestones)
    }

    /// 1-based index of a stage for display ("1. Foundation").
    /// Returns nil (not a misleading 1) if the stage truly isn't
    /// found, so callers can decide how to handle that explicitly.
    func stageIndex(for stage: RoadmapStage) -> Int? {
        guard let index = stages.firstIndex(where: { $0.id == stage.id }) else { return nil }
        return index + 1
    }
}
