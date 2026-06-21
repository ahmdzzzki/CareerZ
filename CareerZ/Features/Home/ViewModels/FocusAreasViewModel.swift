//
//  FocusAreasViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class FocusAreasViewModel {
    var focusAreas: [FocusArea]

    init(focusAreas: [FocusArea] = FocusArea.sample) {
        self.focusAreas = focusAreas
    }
}
