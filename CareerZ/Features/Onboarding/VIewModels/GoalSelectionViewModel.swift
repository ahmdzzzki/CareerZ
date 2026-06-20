//
//  GoalSelectionViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

@Observable
final class GoalSelectionViewModel {
    
    var searchText: String = ""
    var selectedGoal: CareerGoalOption?
    
    let goals: [CareerGoalOption] = [
        CareerGoalOption(
            title: "Product Manager",
            subtitle: "Strategy, Roadmaps & Delivery",
            systemImage: "briefcase.fill",
            color: .blue,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Software Engineer",
            subtitle: "Development & Architecture",
            systemImage: "chevron.left.forwardslash.chevron.right",
            color: .cyan,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "UI/UX Designer",
            subtitle: "Visual Design & Research",
            systemImage: "paintpalette.fill",
            color: .green,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Data Analyst",
            subtitle: "Insights & Statistical Modeling",
            systemImage: "chart.line.uptrend.xyaxis",
            color: .red,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Business Analyst",
            subtitle: "Business Process & Requirements Analysis",
            systemImage: "doc.text.magnifyingglass",
            color: .yellow,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Project Manager",
            subtitle: "Planning, Execution & Team Coordination",
            systemImage: "calendar.badge.checkmark",
            color: .purple,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Data Scientist",
            subtitle: "Machine Learning & Predictive Modeling",
            systemImage: "brain.head.profile",
            color: .indigo,
            imageName: "productManager"
        ),
        CareerGoalOption(
            title: "Digital Marketer",
            subtitle: "Campaigns, Analytics & Growth Strategy",
            systemImage: "megaphone.fill",
            color: .orange,
            imageName: "productManager"
        )
    ]
    
    var filteredGoals: [CareerGoalOption] {
        guard !searchText.isEmpty else { return goals }
        
        return goals.filter { goal in
            goal.title.localizedCaseInsensitiveContains(searchText) ||
            goal.subtitle.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var canContinue: Bool {
        selectedGoal != nil
    }
    
    func selectGoal(_ goal: CareerGoalOption) {
        selectedGoal = goal
    }
}
