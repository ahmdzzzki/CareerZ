# CareerZ website

English product website for the existing iPhone/iPad app. Uses the CareerZ blue palette, grouped gray background, white cards, original illustrations, and real build-3 demonstration screenshots. It clearly states that the App Store release is in progress; no public download availability is claimed.

## Development

From this directory:

```sh
npm ci
npm run dev
npm run build
npm run preview
```

Motion's vanilla JavaScript API provides finite entrances, viewport reveals, and hover feedback. Reduced Motion disables scripted movement and responds to live preference changes. Essential text stays available without JavaScript. The app tour supports keyboard-operated tabs; six career cards display examples derived from the bundled mission content. Keep these examples aligned with `CareerZ/Resources/CareerKnowledge` when app content changes.

Screenshots and original illustrations are in `public/app`. Do not present demonstration scores as a user's real activity. No tracking, external fonts, signup forms, or analytics scripts are installed.

## Vercel / GitHub

- Project: `ahmdzzzkis-projects/careerz` (`prj_OhAunMD0DAUzEN0R4mkEGP6pwjek`).
- Connected repository: `ahmdzzzki/CareerZ`; production branch: `main`.
- Root Directory: `landing-page`; framework: Vite; install: `npm ci`; build: `npm run build`; output: `dist`; Node.js 24.
- Public production domain: https://careerz-app.vercel.app/.
- Push website changes to `main` to trigger Vercel's Git integration. Preview branches use Vercel's normal Git workflow.
- Project authentication was disabled with explicit owner approval on 19 October 2026 so public support/privacy pages are accessible.
- Never commit `.vercel/`, `.env*`, credentials, or deployment tokens. Do not deploy the Swift project as the website root.

## Support and privacy

Static pages: `public/support/index.html`, `public/privacy/index.html`. Vite copies them to `dist/support/` and `dist/privacy/`. Public contact: ahzaki95@gmail.com. Update policy copy if actual data handling changes.

## App Store submission kit

`../docs/app-store/submission/index.html` is a local copy/upload helper, not a public web page or an Apple automation. It includes English metadata and links to the required iPhone/iPad screenshots. The age-rating/privacy guide documents source-based suggested answers and Apple references. Reviewer phone numbers must not be published or committed.
