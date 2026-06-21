//
//  HomeViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class HomeViewModel {

    // MARK: - User
    var userFirstName: String

    // MARK: - Readiness
    var readinessProgress: Double      // 0.0 - 1.0
    var readinessMonthlyDelta: Int     // e.g. 5

    // MARK: - Focus Areas (preview row, top items only)
    var focusAreas: [FocusArea]

    // MARK: - Next Step
    var nextStep: NextStep

    init(
        userFirstName: String = "Zaki",
        readinessProgress: Double = 0.75,
        readinessMonthlyDelta: Int = 5,
        focusAreas: [FocusArea] = FocusArea.sample,
        nextStep: NextStep = .sample
    ) {
        self.userFirstName = userFirstName
        self.readinessProgress = readinessProgress
        self.readinessMonthlyDelta = readinessMonthlyDelta
        self.focusAreas = focusAreas
        self.nextStep = nextStep
    }

    /// "Good Morning" / "Good Afternoon" / "Good Evening" based on
    /// the current time on device.
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
}
