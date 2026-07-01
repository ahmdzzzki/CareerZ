//
//  ProgressStatus.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Completion state shared by roadmap milestones and lessons.
/// Single source of truth for the status icon + color so the
/// overview list and detail screens stay visually consistent.
enum ProgressStatus {
    case completed
    case inProgress
    case locked

    var systemImage: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .inProgress: return "circle.fill"
        case .locked: return "lock.fill"
        }
    }

    var color: Color {
        switch self {
        case .completed: return .appSuccess
        case .inProgress: return .appInfo
        case .locked: return .appTextTertiary
        }
    }

    var accessibilityDescription: String {
        switch self {
        case .completed: return "Completed"
        case .inProgress: return "In progress"
        case .locked: return "Locked"
        }
    }
}
