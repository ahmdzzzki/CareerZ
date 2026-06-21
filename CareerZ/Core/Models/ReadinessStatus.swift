//
//  ReadinessStatus.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Status bucket derived from any percentage-based score.
/// Single source of truth for thresholds + color + label so every
/// screen (Home, Career Readiness, Focus Areas) stays in sync.
enum ReadinessStatus {
    case strong
    case average
    case needsImprovement

    init(percent: Int) {
        switch percent {
        case 70...:
            self = .strong
        case 50..<70:
            self = .average
        default:
            self = .needsImprovement
        }
    }

    var label: String {
        switch self {
        case .strong: return "Strong"
        case .average: return "Average"
        case .needsImprovement: return "Needs Improvement"
        }
    }

    var color: Color {
        switch self {
        case .strong: return .appSuccess
        case .average: return .appWarning
        case .needsImprovement: return .appDanger
        }
    }
}
