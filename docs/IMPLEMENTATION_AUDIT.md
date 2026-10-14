# CareerZ implementation audit — 14 October 2026

The master handoff governs the product: Discover → Decide → Develop; Compass and domain skill proficiency are separate systems. The previous five-dimension readiness assessment is deferred. Product Management is the first development vertical slice. No backend, accounts, analytics, or AI services are introduced.

## Baseline

Feature-first SwiftUI with Observation, shared theme/components, HomeRoute navigation, AppStorage onboarding flag, six domain identifiers, PM skill JSON, and a 60/40 skill engine. Deployment target is iOS 26.5. Main points of debt:

- Home and readiness screens use a sample name, scores, trend, and history.
- Roadmap uses sample completed/locked milestones. Lesson navigation is a TODO.
- Existing assessment records string answers without producing a stored domain result.
- No SwiftData container, assessment history, milestone persistence, or tests.
- Xcode project contains a stale reference to a nonexistent nested CareerZ.xcodeproj.

## Implementation order

1. Validate domain contracts and bundled content; test deterministic scoring and content integrity.
2. Implement eight-trait Compass and six weighted, explainable domain matches. Version question content and retain exact answers.
3. Persist sessions, direction, and mission evidence locally through SwiftData. Never substitute an in-memory store when disk storage fails.
4. Implement PM assessment using behavioral capability descriptors and evidence, ranked gaps, and the ten Foundation → Practice → Portfolio missions. Preserve prerequisites and require user completion rather than inferring it from scores.
5. Connect native screens to stored data, including reassessment history, first-assessment state, reset actions and disclaimers. Retain theme/components; isolate legacy prototype screens until they can be adapted to real models.
6. Verify domain tests and simulator build. Release follow-up: physical-device/offline/relaunch testing, accessibility review, content review with target users, archive/TestFlight, metadata/privacy/support assets, App Review.

## Boundaries

Compass is a reflective heuristic, not a validated psychometric instrument or probability of success. PM skill scores are self-reported proficiency, not employability. Evidence text is a user record, not an external verification. Non-PM domain development content is not claimed to be available. Local data deletion requires an explicit destructive confirmation.
