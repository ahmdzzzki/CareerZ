//
//  HomeRoute.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// Navigation destinations reachable from Home.
/// Conforms to Hashable so it can be used as a NavigationLink value.
enum HomeRoute: Hashable {
    case careerReadiness
    case focusAreaDetail(FocusArea)
    case focusAreaAll
}
