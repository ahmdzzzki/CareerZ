# CareerZ release checklist

This is an engineering development pilot, not a claim of App Store readiness.

## Implemented scope

- Native Discover/Develop/Profile entry path; legacy sample dashboards are not shown to users.
- Forty Compass statements, six domain matches, trait explanations, close-result copy, selectable directions.
- Eight-skill PM capability/evidence assessment; score breakdown, top-three gaps and rule-based next actions.
- Ten PM missions, prerequisites, optional validation, evidence/reflection notes, explicit completion, undo, retained dates.
- Versioned SwiftData local storage; additive reassessment history, first-assessment state, per-skill comparisons.
- About assessment, local-data explanation, separate reset controls and confirmed permanent deletion.
- Privacy manifest declaring no tracking/data collection and UserDefaults for app-local preferences. Review the exact archive’s privacy report before submission; a manifest does not submit App Store Connect privacy answers.

Manifest structure follows [Apple TN3183](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest).
- Foundation/persistence test suite and simulator UI tests on a shared Xcode scheme.

## Before TestFlight

- Review question wording and trait/domain weights with students/fresh graduates; do not imply validated psychometrics.
- Review PM targets and mission artifacts with practicing PMs. Content is lightweight original guidance, not a full course.
- Test full ten-mission journey, undo dependency chain, direction changes, interrupted assessment, storage failure handling, airplane mode, device restart, backup/restore.
- Confirm 40-question length and behavior with target users. Assessment answers currently save at completion; notes save explicitly. Consider resumable drafts after evaluating completion friction.
- Review Dynamic Type (including accessibility sizes), VoiceOver reading/focus, contrast in both appearances, iPad layout, Reduce Motion.
- Add downloadable/exportable evidence/history only if user research demonstrates need; avoid scope creep.
- Confirm minimum supported iOS version (currently 26.5), signing, privacy manifest required API declarations, and App Store Connect privacy answers for the exact release binary.
- Signed device archive, install on physical device, upload TestFlight, and test the distributed build.

## Before App Review

- Product name/subtitle/description/keywords/category and age rating.
- Real device screenshots from the released flow; no illustrative scores presented as user activity.
- Public support URL/contact and privacy policy URL. No invented contact addresses.
- Review notes describing offline-only storage and the PM development pilot.
- Reconcile marketing landing page with available app features; do not claim all six development journeys are complete.
- App icon already exists; review sizes/appearance and branding before submission.
