# App Store screenshots

Captured from the actual app on dedicated iOS 26.5 simulators, using owner-independent demonstration answers entered through the UI. Screens show the current release candidate (build 3 preparation); simulator CloudKit is intentionally disabled. Match the final uploaded build before submitting screenshots. These are screenshot candidates, not evidence of physical-device or Production iCloud verification. Do not use Profile simulator-only sync messaging in store screenshots.

- iPhone 17 Pro: 1206 × 2622, Dynamic Island medium group.
- iPad Pro 13-inch M5: 2064 × 2752; PM assessment, mission completion, and relaunch flow passed.

Regenerate via `CareerZUITests/JourneyUITests/testCaptureStoreScreenshots` on a dedicated test simulator. The test resets its app data, completes a PM assessment and one mission, checks relaunch persistence, then captures Roadmap, Home, Discover, and Mobile details. Export with `xcrun xcresulttool export attachments`. Review screenshots before upload.
