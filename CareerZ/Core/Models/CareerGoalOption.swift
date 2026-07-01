//
//  CareerGoalOption.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

struct CareerGoalOption: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let systemImage: String
    let color: Color
    let imageName: String
}

extension CareerGoalOption {
    /// Placeholder goal used wherever a real persisted user goal
    /// isn't wired up yet (e.g. NextStepDetailView). Remove once
    /// UserSession provides the actual onboarding selection.
    static let sampleProductManager = CareerGoalOption(
        title: "Product Manager",
        subtitle: "Strategy, Roadmaps & Delivery",
        systemImage: "briefcase",
        color: .blue,
        imageName: "productManager"
    )
}
 
