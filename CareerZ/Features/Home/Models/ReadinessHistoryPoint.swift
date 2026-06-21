//
//  ReadinessHistoryPoint.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// One month's readiness percentage, used to plot the
/// "Readiness Over Time" chart.
struct ReadinessHistoryPoint: Identifiable {
    let id = UUID()
    let monthLabel: String   // "Jan", "Feb", ...
    let percent: Int
}

extension ReadinessHistoryPoint {
    static let sample: [ReadinessHistoryPoint] = [
        ReadinessHistoryPoint(monthLabel: "Jan", percent: 58),
        ReadinessHistoryPoint(monthLabel: "Feb", percent: 61),
        ReadinessHistoryPoint(monthLabel: "Mar", percent: 65),
        ReadinessHistoryPoint(monthLabel: "Apr", percent: 70),
        ReadinessHistoryPoint(monthLabel: "May", percent: 75),
    ]
}
