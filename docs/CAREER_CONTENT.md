# Six career development journeys — 19 October 2026

The user's latest instruction expands the original PM pilot to all six domains. Each domain has eight skills, 0–4 capability/evidence assessment, deterministic 60/40 proficiency, weighted non-negative gaps, top-three focus priorities, recommendations, ten missions, completion/undo, retained history and reassessment. The app uses one shared journey implementation and English content throughout.

| Domain | Content prefix | Skills | Missions |
|---|---|---:|---:|
| Software Engineering | software_engineering | 8 | 10 |
| Mobile Development | mobile_development | 8 | 10 |
| Product Design | product_design | 8 | 10 |
| Product Management | product_management | 8 | 10 |
| Data & Analytics | data_analytics | 8 | 10 |
| AI & Machine Learning | artificial_intelligence | 8 | 10 |

## Content and progression

The taxonomy follows the user's master handoff. PM weights and targets remain unchanged. The other domains' positive weights total 100%; their targets are initial practice/portfolio goals, not measured hiring standards or validated assessments. Level 4 means evidence used in a real context with feedback, not expert status. Each descriptor distinguishes conceptual understanding, guided application, independent work and contextual evidence.

New missions cover three Foundation, four Practice and three Portfolio activities, with domain-specific tasks, expected artifacts, reasons and reflection prompts. For example, Data includes SQL validation, cleaning, statistical limitations and reproducibility; ML includes a non-model baseline, data leakage checks, controlled experiments, evaluation, model cards and a local inference demo. Existing PM identifiers and recorded progress are retained.

Stage order precedes gap priority; within eligible missions, gap priority ranks what to do next while prerequisites remain intact. Already-met skill targets produce Optional Validation, never fake completion. All 48 skills appear as primary or supporting mission skills. Learners keep evidence and reflection notes and can reverse completion while preserving prerequisites.

All instructional activity text is bundled and available offline. Optional domain reading links open the browser and do not gate completion. These are original self-directed activities, not reproduced third-party lessons, certifications, or a full course platform.

## Persistence

No SwiftData schema change is needed: versioned assessment payloads already contain a domain, and mission IDs are globally distinct. The selected direction controls the active skill definitions, filtered history, evidence, focus areas and roadmap. Switching direction keeps other domains' records. Trends compare assessments within the current domain only. Profile displays all-career assessment counts and current-career mission counts.

Reset history and reset progress remain global and say so in confirmation copy. Domain switching during an assessment or a stale mission action is rejected. Native CloudKit sync carries the same records; actual cross-device verification and Production setup remain release requirements documented in `APPLE_SERVICES.md`.

## Further reading

- [MDN testing fundamentals](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Testing)
- [Apple accessibility](https://developer.apple.com/documentation/accessibility)
- [GOV.UK user research](https://www.gov.uk/service-manual/user-research)
- [GOV.UK agile delivery](https://www.gov.uk/service-manual/agile-delivery)
- [PostgreSQL tutorial](https://www.postgresql.org/docs/current/tutorial.html)
- [scikit-learn common pitfalls](https://scikit-learn.org/stable/common_pitfalls.html)

Before App Review, have practitioners review question wording, domain weights/targets and mission feasibility. Verify physical-device accessibility, signed TestFlight behavior and live iCloud synchronization. Feature coverage is not a substitute for those release checks.
