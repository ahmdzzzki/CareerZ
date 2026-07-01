//
//  CardBackground.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI

/// Standard solid card surface for content-layer cards (Career
/// Readiness, Focus Areas, Next Step, accordion lists, etc).
///
/// Per Apple's HIG, Liquid Glass belongs to the functional layer
/// (buttons, nav, toolbars) — not the content layer. Applying
/// `.glassEffect()` directly to content cards produces a muddy,
/// over-glassed look since there's nothing scrolling underneath for
/// it to refract. Content cards use a flat, theme-aware surface
/// instead; only `AppButton` and navigation chrome use real glass.
struct CardBackground: ViewModifier {
    var cornerRadius: CGFloat = AppRadius.lg

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.appBackground)
            }
            // No shadow by default: Apple's flat content-card guidance
            // and the original sketch both show clean, shadow-free
            // cards rather than a "floating" look.
    }
}

extension View {
    func cardBackground(cornerRadius: CGFloat = AppRadius.lg) -> some View {
        modifier(CardBackground(cornerRadius: cornerRadius))
    }
}
