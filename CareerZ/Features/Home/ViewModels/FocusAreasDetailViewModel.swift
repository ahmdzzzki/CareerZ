//
//  FocusAreasDetailViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class FocusAreaDetailViewModel {
    let focusArea: FocusArea

    /// Exclusive accordion for "Measured by" rows, same pattern as
    /// Career Readiness's score breakdown.
    var expandedMetricID: String?

    init(focusArea: FocusArea) {
        self.focusArea = focusArea
    }

    func isExpanded(_ metric: FocusAreaMetric) -> Bool {
        expandedMetricID == metric.id
    }

    func toggleExpanded(_ metric: FocusAreaMetric) {
        expandedMetricID = (expandedMetricID == metric.id) ? nil : metric.id
    }
}
