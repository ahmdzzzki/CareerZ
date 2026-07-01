//
//  ProfileMenuItem.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import Foundation

/// One tappable row in the Profile sheet (e.g. "Career Goal",
/// "Help & Support"). `trailingValue` shows a short value preview
/// on the row itself, e.g. "Product Manager" — pass nil to omit.
struct ProfileMenuItem: Identifiable, Hashable {
    let id: String
    let title: String
    let systemImage: String
    var trailingValue: String? = nil
}
