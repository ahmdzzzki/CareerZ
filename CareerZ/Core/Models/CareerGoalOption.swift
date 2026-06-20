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
