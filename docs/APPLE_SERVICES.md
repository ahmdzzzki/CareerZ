# Apple identity and private iCloud sync

Added at the user's explicit request on 16 October 2026, superseding the previous no-login/no-cloud scope. Sign in with Apple remains optional. It stores only the opaque Apple user identifier in the device Keychain; name/email scopes are not requested. There is no CareerZ server or server account. Disconnect removes that local connection without deleting progress. Apple access can be revoked in Apple Account settings, and credential state is checked on foreground/revocation.

CloudKit uses the device's iCloud account independently of Apple sign-in. On signed device builds, SwiftData syncs assessment snapshots, selected direction and mission notes/completion through the private `iCloud.com.academy.CareerZ` database. Local writes remain available offline. Availability is not shown as successful synchronization; actual CloudKit event state is reported separately. Simulator builds intentionally keep a local-only store and disclose this in Profile.

Schema V1 remains unchanged for migration. V2 removes unsupported uniqueness constraints and supplies defaults, using a lightweight migration. History is de-duplicated by stable assessment UUID; mutable direction and mission copies are resolved by most recent edit timestamp (device clock). Concurrent note edits are not text-merged; keep both device clocks accurate. This is eventual sync, not real-time collaboration. Imported records trigger a UI refresh. The profile display name stays device-local.

Reset/delete operations affect the synced records too; confirmations explain propagation to other devices. Disconnecting Apple does not turn off device iCloud or delete its data. Resetting progress does not revoke Apple authorization.

## Configuration

- Keep the existing bundle ID `com.academy.CareerZ` and signing team.
- Target entitlements: Sign in with Apple, iCloud/CloudKit container and push notifications. `Configuration/Info.plist` adds the remote-notification background mode.
- Debug uses CloudKit Development; Release uses Production. The simulator still uses `.none` for its SwiftData configuration.
- Existing development provisioning was inspected and contains the Apple sign-in and requested iCloud container permissions. A signed device build succeeded.

## Required live verification before shipping

1. Run a Debug build on a physical device signed into iCloud. Verify Apple sign-in, cancel, relaunch, disconnect and revocation in device settings. Check credential storage errors are surfaced.
2. Create real assessment/mission records to initialize the Development schema. Test two physical devices on the same iCloud account: history, notes, completion/undo, direction, offline edits/reconnect and delayed imports.
3. Test account availability changes, restricted/no iCloud, conflicting edits, targeted reset and deletion propagation. Confirm no accidental transfer between iCloud accounts.
4. In Apple's CloudKit Console, inspect the Development schema and deploy it to Production before a Release/TestFlight build. Do not assume archive success deploys the CloudKit schema.
5. Test the Production environment through TestFlight, including deletes and reinstall/restore. Review privacy policy, App Store privacy answers and screenshot/landing-page claims for the exact distributed binary.

No live Apple login, cloud round-trip, two-device synchronization or Production schema deployment has been verified by the simulator tests.

Native platform references: [SwiftData iCloud synchronization](https://developer.apple.com/documentation/swiftdata/syncing-model-data-across-a-persons-devices) and [Sign in with Apple authentication](https://developer.apple.com/documentation/authenticationservices/implementing-user-authentication-with-sign-in-with-apple).
