# CareerZ 1.0 — release handoff, 19 October 2026

## Latest update — free worldwide, App Privacy publication still blocked

The owner explicitly confirmed free pricing and availability in all Apple-supported territories. The App Store price schedule now reads customer price/proceeds 0.0. Availability was created for all 175 returned territories, including availability in new territories. These settings were read back successfully; the earlier pricing approval block is resolved.

The owner reported publishing App Privacy, but Apple still returned HTTP 409 `APP_DATA_USAGES_REQUIRED` when adding version 1.0 to the review submission, including after a delayed retry. No other validation errors remained in that response. The owner was asked to verify both the page-level Publish action and its final confirmation dialog for the data-collection answers. Saving the policy URL is a separate action. The public API does not expose this App Privacy label-publication flow. Submission is still NOT sent.

## Latest listing update — metadata saved, submission not sent

On 19 October 2026, authenticated App Store Connect API access was established using an owner-provided team key kept outside the repository. English description/keywords/promotional text, support/marketing/privacy URLs, subtitle, Education/Productivity categories, source-based age questionnaire (Apple calculated 4+), copyright, build 3 selection, optional sign-in, private review contact, and review notes were saved successfully. The existing release-after-approval selection was retained. Eight real screenshot candidates were uploaded; all returned `COMPLETE` without asset errors.

Apple rejected adding version 1.0 to the draft review submission because two requirements remain: published App Privacy data-usage answers and app pricing. The public API has no supported App Privacy label-editing endpoint; the owner was asked to Publish those answers through the UI. A pricing change to free was stopped by automatic approval review pending explicit owner confirmation of price/territories. Pricing and availability have not been set by this attempt. No final review submission has occurred. The created review-submission container is a draft, even though its API state is named READY_FOR_REVIEW.

Read-back receipt: `app-store/submission/apple-status.json`. It excludes private reviewer contact details and API credentials. Private key and JWTs are never committed or printed. Earlier no-access/blank-listing statements below are historical.

## Latest verified status — build 3 uploaded

Xcode Organizer's archive receipt confirms **CareerZ 1.0 (3) uploaded successfully on 19 October 2026 at 14:07 WIB (07:07 UTC)** for App Store app `6824272166`, with no upload errors or warnings. ContentDelivery also reports `UPLOAD SUCCEEDED with no errors` and Apple state `PROCESSING` at upload completion. See `app-store/build-3-upload-receipt.json` for the minimal receipt. Current processing completion, version/build association, icon visibility in the authenticated App Store Connect UI, TestFlight availability, and App Review submission have not been verified.

The uploaded archive is `~/Library/Developer/Xcode/Archives/2026-10-19/CareerZ-1.0-3-final.xcarchive`. Choose the processed build 3 in the App Store version's Build section and Save. The account failures and build-2-only status below are historical and superseded by this successful Organizer upload.

## Earlier distribution history

Xcode automatic signing successfully archived and uploaded **version 1.0 (build 2)** to App Store Connect. Upload finished with `Upload succeeded`, `Uploaded CareerZ`, and `EXPORT SUCCEEDED`; Apple then reported that the package was processing. Build 1 was also uploaded during preparation; build 2 includes public support/privacy links. Final review should use the subsequent build 3 candidate once its upload succeeds (see below). Processing completion, TestFlight availability, App Review submission, and public release are not verified by an upload receipt.

- Bundle: `com.academy.CareerZ`; signing team: `3NN7487Y49`.
- Archive: `/tmp/CareerZ-1.0-2.xcarchive`.
- Exported distribution package: `/tmp/CareerZ-1.0-2-export/CareerZ.ipa`.
- Upload log: `/tmp/careerz-build2-upload.log`.
- Export log: `/tmp/careerz-build2-export.log`.
- Effective distribution entitlements checked: CloudKit `Production`, private container `iCloud.com.academy.CareerZ`, Apple sign-in, production APNs, and `get-task-allow = false`.
- Main 1024px App Store icon now has an opaque white background, with original logo preserved. Apple applies the platform icon mask.
- `ITSAppUsesNonExemptEncryption = false` is included in the archived Info.plist. This app uses Apple-provided encryption (CloudKit, Keychain, Apple authentication) and no custom cryptographic implementation. Re-evaluate if dependencies or encryption use change.

No signing keys, provisioning profiles, tokens, IPA files, or account credentials are committed to Git. `/tmp` artifacts are temporary; preserve the archive/IPA elsewhere before cleaning the machine.

## Public web

Owner-approved project: `ahmdzzzkis-projects/careerz`.

- https://careerz-app.vercel.app/
- https://careerz-app.vercel.app/support/
- https://careerz-app.vercel.app/privacy/
- Contact: ahzaki95@gmail.com (provided by owner).

Vercel reports production deployment `READY`; alias points to deployment `careerz-kebcse774-ahmdzzzkis-projects.vercel.app`. Owner explicitly approved disabling project Vercel Authentication so these pages can be public; API confirmed `ssoProtection = null`. Local production build passed; browser checks at 390px and 1440px found no horizontal overflow, broken images, or page errors on home/support/privacy. This is local browser verification, not an HTTP check of the deployed URL.

The website now describes all six career journeys and optional iCloud, includes support/privacy pages, and retains coming-soon download copy until Apple release is actually live. Vercel account/project dashboard URLs are not public support URLs. Keep `.vercel/` and `.env*` ignored. The verified `careerz-app.vercel.app` domain is attached to the CareerZ project for future production deployments.

## Verification

- Domain/content/persistence: 24 tests passed.
- Signed Release archive and App Store export: passed.
- Upload to Apple: passed; processing started.
- Final iPhone PM flow: assessment → mission completion → relaunch → retained history/progress passed (`/tmp/CareerZ-store-iphone-verified.xcresult`); four full-screen screenshot candidates captured at 1206×2622.
- Screenshot UI tests use dedicated simulators and explicitly entered demonstration answers. They reset app data through UI; never run them on a user's personal simulator.
- iPad Pro 13-inch PM flow passed after the full-screen/keyboard fixes (`/tmp/CareerZ-store-ipad-final.xcresult`); four screenshot candidates at 2064×2752 are in `docs/app-store/screenshots/ipad`.
- Actual Apple sign-in, two-device CloudKit Production sync, physical-device offline/relaunch behavior, and full accessibility review are still release gates.

## Follow-up iPad fixes (build 3 preparation)

After build 2 upload, iPad screenshot verification exposed that the default assessment sheet did not consistently accept the automated answer/Continue sequence. Assessments now use native full-screen presentation from all three entry points; the full iPhone PM route passed again. Mission notes now have a keyboard Done action so the completion footer can be reached explicitly. Final iPhone and iPad verification passed: assessment, mission completion, relaunch retention, and full-screen screenshot captures. The UI helper dismisses the keyboard before scrolling to an obscured field.

A later distribution export of build 3 stopped with `No Accounts` / no iOS Distribution certificate. Xcode's account preference list is currently empty. The owner was asked to re-add the Apple Account and confirm team `3NN7487Y49` in Xcode → Settings → Accounts. Final signed development archive with these fixes: `/tmp/CareerZ-1.0-3-final.xcarchive`. **Build 3 is not uploaded yet**; build 2 remains the last confirmed upload. Do not describe the iPad fixes as part of uploaded build 2.

## Owner actions in Apple dashboards

1. In [CloudKit Console](https://icloud.developer.apple.com/), select the correct developer team and `iCloud.com.academy.CareerZ`. Open Development → Schema → Deploy Schema Changes, inspect the diff, and deploy to Production. If schema is empty, initialize it from a signed Development build before deploying; do not manually invent record types. Do not reset/delete an existing environment. Apple documentation: https://developer.apple.com/documentation/CloudKit/deploying-an-icloud-container-s-schema.
2. In [App Store Connect](https://appstoreconnect.apple.com/apps), open CareerZ → TestFlight. Wait for build 1.0 (2) to finish processing, answer any remaining compliance questions, add an internal tester, and install via TestFlight. Verify offline assessments, persistence, optional Apple sign-in, sync on two devices using the same iCloud account, deletion propagation, and relaunch.
3. Open App Store → iOS 1.0. Paste `APP_STORE_DRAFT.md` copy and URLs, choose the latest verified build 3 after upload succeeds, add screenshots, complete App Privacy/age rating/content rights/pricing/availability, and fill the actual reviewer contact name/email/phone. These details are not inferred from a signing certificate.
4. Submit for App Review after the live gates pass. The owner has authorized release work, but this session has no App Store Connect API key or authenticated dashboard-control tool to fill these forms or press Submit for Review. Do not share passwords/OTP in chat.

Upload alone does not publish the application. No App Review submission has been made or claimed.

## Reproduce the next distribution upload

After restoring Xcode Accounts, use the archive with the verified iPad fixes:

```sh
xcodebuild -exportArchive \
  -archivePath /tmp/CareerZ-1.0-3-final.xcarchive \
  -exportPath /tmp/CareerZ-1.0-3-upload \
  -exportOptionsPlist Configuration/AppStoreUploadOptions.plist \
  -allowProvisioningUpdates
```

`Configuration/AppStoreExportOptions.plist` exports an IPA instead. Both configurations use Production iCloud, the existing signing team, and the explicit build number from the archive. Increment `CURRENT_PROJECT_VERSION` before uploading another binary with an already-used build number. No App Store password or API key is stored in these files.

## Icon and account follow-up — 19 October 2026

The owner reported a missing logo on the App Store Connect version page. Local inspection confirmed `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`, a 1024×1024 opaque base PNG, generated `CFBundleIcons`/`CFBundleIconName = AppIcon` in the distribution package, and compiled 1024×1024 icon renditions for iPhone and iPad in build 3's `Assets.car`. No missing application icon file was found, and no replacement branding was introduced.

The App Store Connect page itself has not been inspected through an authenticated browser-control tool. Associate a processed build in the version page's Build section, then Done → Save. Apple documents the icon/build string appearing in that section: https://developer.apple.com/help/app-store-connect/manage-builds/choose-a-build-to-submit/. Use the final verified build 3 for submission once uploaded.

The owner added team settings to the UI-test target; those local project changes are preserved. A new build 3 upload attempt still failed, now specifically with `Failed to Use Accounts — App Store Connect access for 3NN7487Y49 is required`. Reauthenticate the Apple Account in Xcode Settings → Accounts and verify its access to CareerZ in App Store Connect. This is account access, not an icon-asset compilation failure. Log: `/tmp/careerz-build3-upload.log`. Build 3 has not been uploaded by this attempt.

After the owner confirmed reauthentication, a further upload retry still returned `Failed to Use Accounts` (log `/tmp/careerz-build3-upload-retry.log`). The verified archive `/tmp/CareerZ-1.0-3-final.xcarchive` was opened with Xcode for distribution through Organizer. Use Distribute App → TestFlight & App Store; older/custom flows label this App Store Connect → Upload. This opening action is not an upload receipt: build 3 remains unconfirmed until Organizer reports upload success.
