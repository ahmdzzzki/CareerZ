# CareerZ release checklist

This is an engineering development pilot, not a claim of App Store readiness.

## Implemented scope

- Native Home/Discover/Roadmap/Profile entry path; legacy sample dashboards are not shown to users.
- Forty Compass statements, six domain matches, trait explanations, close-result copy, selectable directions.
- Eight-skill capability/evidence assessment for each of six domains; score breakdown, top-three gaps and rule-based next actions.
- Ten missions per domain (60 total), prerequisites, optional validation, evidence/reflection notes, explicit completion, undo, retained dates.
- Versioned SwiftData local storage; additive reassessment history, first-assessment state, per-skill comparisons.
- About assessment, local-data explanation, separate reset controls and confirmed permanent deletion.
- Privacy manifest declaring no tracking/data collection and UserDefaults for app-local preferences. Review the exact archive’s privacy report before submission; a manifest does not submit App Store Connect privacy answers.

Manifest structure follows [Apple TN3183](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest).
- Foundation/persistence test suite and simulator UI tests on a shared Xcode scheme.

## Before TestFlight

- Review question wording and trait/domain weights with students/fresh graduates; do not imply validated psychometrics.
- Review each domain’s targets and mission artifacts with practitioners in that field. Content is lightweight original guidance, not a full course.
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
- Review notes describing offline storage, optional Apple sign-in/private iCloud sync and the six-domain development journey.
- Reconcile marketing landing page with available app features; check domain content and match claims to the exact shipped build.
- App icon already exists; review sizes/appearance and branding before submission.

- Apple services are now in scope: complete every physical-device and Production-schema check in [APPLE_SERVICES.md](APPLE_SERVICES.md). Review all privacy/marketing claims that still describe the earlier local-only scope before publishing.
