//
//  NextStepDetailViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class NextStepDetailViewModel {
    let nextStep: NextStep

    /// Career goal used to pick the right question set when starting
    /// the assessment. Hardcoded to a sample goal for now — once
    /// onboarding's selected goal is persisted (UserSession, planned
    /// separately), this should be read from there instead.
    let careerGoal: CareerGoalOption

    init(
        nextStep: NextStep = .sample,
        careerGoal: CareerGoalOption = .sampleProductManager
    ) {
        self.nextStep = nextStep
        self.careerGoal = careerGoal
    }
}
