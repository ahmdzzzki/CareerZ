//
//  FocusAreaMetric.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// One "Measured by" sub-metric within a focus area's detail screen
/// (e.g. "Professional Connections" under Networking). Expandable
/// inline, same accordion pattern as ScoreBreakdownRow.
struct FocusAreaMetric: Identifiable {
    let id: String
    let title: String
    /// One-line summary shown collapsed, under the title.
    let summary: String
    /// Longer explanation shown when expanded.
    let detail: String
}
