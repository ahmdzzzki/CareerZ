//
//  ProfileViewModel.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation
import Observation

@Observable
final class ProfileViewModel {

    var userName: String
    /// Shown as the career goal value next to "Career Goal" and used
    /// to build that row's trailing value. Hardcoded for now — once
    /// UserSession exists, this should read the real selected goal.
    var careerGoalTitle: String

    init(userName: String = "Ahmad Zaki", careerGoalTitle: String = "Product Manager") {
        self.userName = userName
        self.careerGoalTitle = careerGoalTitle
    }

    var careerItems: [ProfileMenuItem] {
        [
            ProfileMenuItem(id: "career-goal", title: "Career Goal", systemImage: "target", trailingValue: careerGoalTitle),
            ProfileMenuItem(id: "assessment-results", title: "Assessment Results", systemImage: "doc.text"),
        ]
    }

    var notificationsItem: ProfileMenuItem {
        ProfileMenuItem(id: "notifications", title: "Notifications", systemImage: "bell")
    }

    var aboutItems: [ProfileMenuItem] {
        [
            ProfileMenuItem(id: "help-support", title: "Help & Support", systemImage: "questionmark.circle"),
            ProfileMenuItem(id: "about", title: "About CareerZ", systemImage: "info.circle"),
        ]
    }
}
