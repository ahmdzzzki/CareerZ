//
//  CareerReadinessViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class CareerReadinessViewModel {

    // MARK: - Overall score
    var readinessProgress: Double      // 0.0 - 1.0
    var readinessMonthlyDelta: Int     // e.g. 5

    // MARK: - Breakdown
    var scoreComponents: [ScoreComponent]

    /// Exclusive accordion: only one component expanded at a time.
    /// nil = all collapsed.
    var expandedComponentID: String?

    // MARK: - History
    var history: [ReadinessHistoryPoint]
    var historyDeltaVsLastMonth: Int   // e.g. 12 -> "+12% vs last month"

    init(
        readinessProgress: Double = 0.75,
        readinessMonthlyDelta: Int = 5,
        scoreComponents: [ScoreComponent] = ScoreComponent.sample,
        history: [ReadinessHistoryPoint] = ReadinessHistoryPoint.sample,
        historyDeltaVsLastMonth: Int = 12
    ) {
        self.readinessProgress = readinessProgress
        self.readinessMonthlyDelta = readinessMonthlyDelta
        self.scoreComponents = scoreComponents
        self.history = history
        self.historyDeltaVsLastMonth = historyDeltaVsLastMonth
    }

    func isExpanded(_ component: ScoreComponent) -> Bool {
        expandedComponentID == component.id
    }

    func toggleExpanded(_ component: ScoreComponent) {
        expandedComponentID = (expandedComponentID == component.id) ? nil : component.id
    }
}
