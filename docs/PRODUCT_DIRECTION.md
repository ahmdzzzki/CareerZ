# CareerZ product direction

The master context supplied by Ahmad is the primary product source. Its newer Discover → Decide → Develop model supersedes the original five-dimension readiness prototype, which is deferred.

CareerZ is for university students and fresh graduates exploring technology career directions. It recommends directions worth trying; it does not prescribe a future. v1 is native SwiftUI, English, offline-first, SwiftData-backed, with bundled career knowledge and deterministic rule-based services. No account, backend, cloud sync, AI recommendations, payments, analytics, or advertising.

Implementation order: foundation → CareerZ Compass / Career Discovery → Product Management vertical slice → testing/accessibility/content refinement → TestFlight → App Store.

Compass measures eight tendencies using 40 interleaved statements and a 1–5 scale, including reverse-scored items. Trait scores normalize to 0–100. Six weighted domain matches are explainable and close leading scores are acknowledged. Compass is not a psychometric instrument, probability of success, or technical skill test.

Discovery domains: Software Engineering; Mobile Development; Product Design; Product Management; Data & Analytics; Artificial Intelligence & Machine Learning. Users can choose a direction independently of ranking. Product Management is the first complete development journey; other development taxonomies are future content, not advertised as complete.

PM assessment uses the eight skills in `product_management_skills.json`. Capability × 0.6 + evidence × 0.4 yields a 0–4 proficiency score. Gap is max(portfolio target − proficiency, 0); priority is gap × importance. Portfolio targets are practice goals, not employment thresholds. Level 4 is proven in a context, not expert.

PM roadmap contains ten lightweight, actionable missions across Foundation → Practice → Portfolio. Prerequisites, gaps, and evidence determine ordering/classification. An already-met target permits Optional Validation using an existing artifact, never automatic completion. Completion requires evidence notes and reflection; it does not inflate assessment scores. Reassessment history is retained and comparisons use real stored results; the first assessment has no invented trend.

Release quality: local persistence survives process restart, no fake activity, errors and empty states, safe reset/delete controls, Dynamic Type, VoiceOver, Reduce Motion, adequate contrast, light/dark modes, physical-device/offline testing, signed archive/TestFlight, reviewed content and accurate metadata/privacy/support pages. CareerZ provides personal development guidance, not certification or an employment guarantee.
