# Verification — 14 October 2026

Environment: Xcode 27.0, Swift 6.4; iPhone 17 Pro simulator on iOS 26.5. Tests use a dedicated simulator named CareerZ Verification.

- `swift test --scratch-path /tmp/CareerZ-domain-build`: **18 tests passed**, zero failures. This includes domain/content validation, scoring/reverse scoring, explanation math, latest-result handling, prerequisite ordering, focus-area priorities/count, history comparisons, disk-store reopen, completion validation, undo integrity and reset isolation.
- `JourneyUITests.testCompassShowsExplainableMatchesAndPersists`: passed. Entered 40 real UI answers, saved, checked close matches, opened comparison, relaunched, and recovered Compass results.
- `JourneyUITests.testPMJourneyPersistsAfterRelaunch`: passed in a final standalone run. Selected PM, answered all eight skill/evidence pairs, completed the first mission with notes/reflection, relaunched, verified the first-assessment state and 1/10 mission progress.
- Release iOS archive with `CODE_SIGNING_ALLOWED=NO`: **ARCHIVE SUCCEEDED**. The archive contains all three knowledge JSON files and `PrivacyInfo.xcprivacy`. This unsigned archive cannot be distributed through TestFlight/App Store.
- Xcode project and privacy manifest passed `plutil -lint`; staged diff passed `git diff --cached --check`.

The combined UI run passed Compass but its PM XCTest runner exited with signal TERM. That is not counted as a passing combined suite. PM was rerun separately and passed. Earlier scrolling-helper failures were corrected. Xcode also emits existing generated-color-symbol warnings for PrimaryColor/SecondaryColor and the no-AppIntents metadata warning; these do not block builds.

Not yet verified: physical-device/reboot/airplane-mode testing, all ten missions through UI, accessibility/VoiceOver review, signed archive/export, TestFlight distribution, App Store Connect privacy declarations, or App Review. See the release checklist. Domain test coverage and simulator checks do not substitute for user/content validation of Compass.


## Original-style refinement

Restored the existing brand palette, original onboarding and assessment artwork, rounded card hierarchy, pastel icon tiles and capsule CTAs. Home now presents a real skill snapshot, focus carousel, next action and roadmap summary. The PM assessment uses 16 sequential capability/evidence steps with a persistent bottom CTA. Roadmap groups actual mission state into Foundation, Practice and Portfolio cards.

- Domain/persistence suite: 18 tests passed, including the weighted dashboard metric and rejection of incomplete input.
- PM assessment → mission evidence/reflection → relaunch UI test: passed after updating selectors for restored card labels.
- Home/Roadmap navigation and screenshot UI test: passed; corrected a narrow snapshot layout observed during simulator inspection.
- Inspected actual onboarding, career detail, assessment cards, mission evidence entry, and Home in Light/Dark Mode. Largest Dynamic Type Home inspection prompted a ring-number scaling fix. This is a visual spot check, not a completed app-wide accessibility review.
- Reference Home screenshots in `docs/screenshots` contain assessment values entered on the dedicated test simulator, not seeded user activity.

- Final standalone Compass UI run: passed (40 answers, explanation/comparison, and persisted results after relaunch). Final unsigned Release archive: succeeded.
