# CareerZ Step 01 — Product Foundation

This patch deliberately does not redesign the UI yet.

## Added
- Shared career-domain identifiers
- Shared 0–4 skill-level model
- Skill definitions and assessment result contracts
- Mission definition contracts
- Pure `SkillAssessmentEngine`
- Local JSON loader
- Product Management skill taxonomy JSON

## Fixed
- Removed the forced onboarding reset in `ContentView`.

## Not added yet
- SwiftData persistence
- Compass assessment UI
- PM assessment UI
- Roadmap generation UI
- App Store metadata

## Next implementation step
Load `product_management_skills.json`, expose the eight skills through a PM assessment ViewModel, and add a unit-test target for the scoring engine.
