# Age ratings and App Privacy — build 3

These are content-based answers prepared from CareerZ's actual code and bundled guidance. The age-rating questionnaire has now been saved through Apple’s API, which calculated 4+. App Privacy label answers still require Publish in the Apple UI. The app has NOT been sent to App Review. Apple calculates the final regional age ratings; do not force a rating to skip the questionnaire.

## App Information → Age Ratings → Set Up / Edit

- Parental controls: No.
- Age assurance: No. CareerZ does not verify or estimate a user's age.
- Unrestricted web access: No. Fixed optional reading links open externally; CareerZ has no free web browser.
- User-generated content: No. Personal notes stay private; users cannot distribute or publish content to other users.
- Messaging and chat: No.
- Social media: No. There is no feed or social distribution. Under-13 social-media restriction is not applicable.
- Advertising: No.
- Profanity/crude humor, horror/fear, mature/suggestive themes: None.
- Medical/treatment information: None. Career guidance is not medical or psychological advice.
- Health/wellness topics: No / None.
- Sexual content/nudity and graphic sexual content: None.
- Cartoon/fantasy, realistic, prolonged graphic/sadistic violence, weapons: None.
- Gambling, simulated gambling, contests, loot boxes: No / None.
- Made for Kids category: Do not select. The target audience is students/fresh graduates; a low calculated content rating does not mean this is a children's app.
- Do not add an age-rating override unless the owner has a specific reason. Let Apple calculate the rating from these answers.

Apple's current categories distinguish broadly distributed user content from personal notes: https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/
Questionnaire: https://developer.apple.com/help/app-store-connect/manage-app-information/set-an-app-age-rating

## App Information → Category

Primary: Education. Secondary (optional): Productivity.

## App Privacy

Privacy Policy URL: https://careerz-app.vercel.app/privacy/

Prepared answer for build 3: **No, we do not collect data from this app**, based on the following inspected implementation:

- Display name/preferences are on-device. Apple sign-in identifier is in the local Keychain; name/email are not requested.
- Responses, notes, history, and completion use local SwiftData and the user's private CloudKit database. There is no public/shared database, custom backend, developer ingestion, or third-party SDK.
- No advertising, tracking, developer-installed analytics, or user-data upload to an AI service.
- Only the user can access their private CloudKit database by default; private data is not visible in the developer portal. This is distinct from collecting user content in a backend controlled by the developer.
- Support emails are voluntarily sent outside the app. The support website's hosting logs are explained in its policy; they are not an iOS analytics SDK.

This answer is an assessment of build 3, not an exemption merely because CloudKit is used. If actual app data becomes accessible to the developer through a backend, public/shared CloudKit, analytics, support upload, or other processing, review and update the privacy labels before release.

Definitions and Apple-services guidance: https://developer.apple.com/app-store/app-privacy-details/
Private database access: https://developer.apple.com/documentation/cloudkit/ckcontainer/privateclouddatabase

## Version 1.0

- Choose processed build 3. Sign-in required: unchecked; demo username/password blank.
- Review contact: actual owner first/last name, phone with country code, and ahzaki95@gmail.com. Phone is for Apple, not the public support site.
- Header, search-results artwork, preview video, routing coverage, App Clip, iMessage, Game Center, and review attachment are not required for this app's current feature set. Leave these optional fields empty.
- The required screenshots are already in ../screenshots/iphone (1206×2622) and ../screenshots/ipad (2064×2752). Upload the actual PNG files into the corresponding device group. Choose Home, Discover, Roadmap, then Explore Mobile.
- Release method: owner can select automatic release after approval to match the requested public launch. Complete real TestFlight and Production CloudKit verification before submitting.
