//
//  AppColor.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 20/06/26.
//

import SwiftUI

extension Color {
    
    // MARK: - Brand Colors
    static let appPrimary = Color("PrimaryColor")
    static let appSecondary = Color("SecondaryColor")
    static let appTertiary = Color("TertiaryColor")
    static let appNeutral = Color("NeutralColor")
    
    // MARK: - Background
    static let appBackground = Color(.systemBackground)
    static let appSecondaryBackground = Color(.secondarySystemBackground)
    static let appGroupedBackground = Color(.systemGroupedBackground)
    
    // MARK: - Text
    static let appTextPrimary = Color(.label)
    static let appTextSecondary = Color(.secondaryLabel)
    static let appTextTertiary = Color(.tertiaryLabel)
    
    // MARK: - Status
    static let appSuccess = Color(.systemGreen)
    static let appWarning = Color(.systemOrange)
    static let appDanger = Color(.systemRed)
    static let appInfo = Color(.systemBlue)
    
    // MARK: - UI
    static let appSeparator = Color(.separator)
    static let appFill = Color(.systemFill)
    static let appSecondaryFill = Color(.secondarySystemFill)
    
    // MARK: - Hex Fallback
    init(hex: String, opacity: Double = 1.0) {
        let cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        
        switch cleanedHex.count {
        case 6:
            (a, r, g, b) = (
                255,
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        case 8:
            (a, r, g, b) = (
                int >> 24,
                int >> 16 & 0xFF,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255 * opacity
        )
    }
}
