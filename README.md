# CareerZ

A native, offline-first iOS career exploration and skill-development app. **Discover → Decide → Develop.**

Open `CareerZ.xcodeproj` and run the shared **CareerZ** scheme on iOS 26.5 or later. The active application flow uses Compass discovery, six career development journeys, (48 skills and 60 missions), and offline SwiftData storage with private CloudKit sync on signed device builds. Apple sign-in is optional. See [Apple services setup and verification](docs/APPLE_SERVICES.md). Legacy prototype screens remain in the tree for incremental design reuse and are not the production entry path.

## Verification

```sh
swift test --scratch-path /tmp/CareerZ-domain-build
xcodebuild -project CareerZ.xcodeproj -scheme CareerZ -configuration Debug \
  -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/CareerZ-build CODE_SIGNING_ALLOWED=NO build
xcodebuild -showdestinations -project CareerZ.xcodeproj -scheme CareerZ
# Replace SIMULATOR_ID with a dedicated test simulator. UI tests reset its CareerZ data.
xcodebuild -project CareerZ.xcodeproj -scheme CareerZ \
  -destination 'platform=iOS Simulator,id=SIMULATOR_ID' \
  -derivedDataPath /tmp/CareerZ-build -parallel-testing-enabled NO \
  CODE_SIGNING_ALLOWED=NO test
```

Domain and persistence tests compile the same source files as the app through Swift Package Manager on macOS. No third-party iOS dependencies are required. SwiftData schema and content snapshots have explicit versions; extend migration handling before changing saved contracts.

See [product direction](docs/PRODUCT_DIRECTION.md), [audit](docs/IMPLEMENTATION_AUDIT.md), [release checklist](docs/RELEASE_CHECKLIST.md), and [agent guide](AGENTS.md). The [landing page](landing-page/README.md) is a separate Vite/Motion website.
