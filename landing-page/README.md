# CareerZ landing page

English concept landing page following Discover → Decide → Develop. Product mockups are explicitly illustrative; the iOS app is in development. No forms, tracking, external fonts, or account flows.

## Local development

```sh
npm ci
npm run dev
npm run build
npm run preview
```

Motion (the library formerly known as Framer Motion) is bundled locally through Vite using its vanilla JavaScript API. Hero entrances, one-time viewport reveals, a finite compass animation, and pointer hover feedback enhance the existing HTML. No React rewrite is needed. Reduced Motion disables all scripted movement and responds to preference changes while the page is open. The content remains available with JavaScript disabled. Decorative movement finishes in under five seconds.

Deploy this directory only to Vercel, using the Vite build and `dist` output in `vercel.json`; do not upload the iOS project. The logo is copied from the app assets. `.vercel` holds local deployment identity and is ignored by Git.

The design was approved in conversation, following the bounded-change and verification workflow from obra/superpowers. Superpowers is development guidance, not a browser dependency.

## App Store support pages

Static English support and privacy pages live in `public/support/index.html` and `public/privacy/index.html`. Vite copies these into `dist`. Public contact: ahzaki95@gmail.com. Update policy copy when actual data handling changes. No analytics scripts are installed.

Vercel project: `ahmdzzzkis-projects/careerz`. Public alias: https://careerz-app.vercel.app. Project authentication was disabled with explicit owner approval on 19 October 2026. The public domain is attached to the CareerZ project for subsequent production deployments. Local `.vercel/` and `.env*` files must stay ignored.
