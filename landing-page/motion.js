import { animate, hover, inView, stagger } from 'motion';
const preference = matchMedia('(prefers-reduced-motion: reduce)');
const animations = new Set(), cleanups = [], styles = new Map();
function play(targets, frames, options) {
  const elements = typeof targets === 'string' ? [...document.querySelectorAll(targets)] : Array.isArray(targets) ? targets : [targets];
  if (!elements.length) return;
  elements.forEach(el => { if (!styles.has(el)) styles.set(el, el.getAttribute('style')); });
  const control = animate(elements, frames, options);
  animations.add(control); Promise.resolve(control).then(() => animations.delete(control)); return control;
}
function reset() {
  cleanups.splice(0).forEach(cleanup => cleanup()); animations.forEach(a => a.stop()); animations.clear();
  styles.forEach((style, el) => { el.getAnimations().forEach(a => a.cancel()); if (style === null) el.removeAttribute('style'); else el.setAttribute('style', style); }); styles.clear();
}
function start() {
  reset(); if (preference.matches) return;
  const ease = [.22, 1, .36, 1];
  play([...document.querySelector('.hero-copy').children], { opacity: [0, 1], y: [18, 0] }, { duration: .65, delay: stagger(.07), ease });
  play('.hero-product', { opacity: [0, 1], y: [24, 0] }, { duration: .8, ease });
  cleanups.push(inView('.section-head, .steps article, .tour-copy, .tour-screen, .domain-card, .mission-preview, .ownership > div, .faq > div, .closing .wrap', el => { play(el, { opacity: [0, 1], y: [18, 0] }, { duration: .55, ease }); }, { amount: .12 }));
  cleanups.push(hover('.button, .nav-cta', el => { play(el, { y: -3 }, { duration: .18 }); return () => play(el, { y: 0 }, { duration: .18 }); }));
}
preference.addEventListener('change', start); addEventListener('pagehide', reset); addEventListener('pageshow', e => { if (e.persisted) start(); }); start();
const screens = {
  home: ['CareerZ Home with a demonstration skill assessment', 'Home · Example data entered through the app'],
  discover: ['CareerZ Discover with Compass and career directions', 'Discover · Choose a path or start with Compass'],
  roadmap: ['CareerZ Product Management roadmap with one completed demonstration mission', 'Roadmap · Example mission completed through the app'],
};
const tabs = [...document.querySelectorAll('[data-screen]')];
function selectScreen(tab, focus = false) {
  tabs.forEach(t => { t.setAttribute('aria-selected', String(t === tab)); t.tabIndex = t === tab ? 0 : -1; });
  const key = tab.dataset.screen, image = document.querySelector('#tour-image'); image.src = `/app/${key}.png`; image.alt = screens[key][0];
  document.querySelector('#tour-caption').textContent = screens[key][1]; document.querySelector('#screen-panel').setAttribute('aria-labelledby', tab.id);
  if (!preference.matches) play(image, { opacity: [.5, 1] }, { duration: .25 }); if (focus) tab.focus();
}
tabs.forEach((tab, i) => { tab.addEventListener('click', () => selectScreen(tab)); tab.addEventListener('keydown', e => {
  const keys = { ArrowRight: (i + 1) % tabs.length, ArrowDown: (i + 1) % tabs.length, ArrowLeft: (i + tabs.length - 1) % tabs.length, ArrowUp: (i + tabs.length - 1) % tabs.length, Home: 0, End: tabs.length - 1 };
  if (e.key in keys) { e.preventDefault(); selectScreen(tabs[keys[e.key]], true); }
}); });
const missions = {
  "software": [
    "SOFTWARE ENGINEERING",
    "Define a Small Software Problem",
    "Choose a recurring task. Write its inputs, outputs, constraints, and three acceptance examples before picking a solution.",
    "A scoped problem brief and three acceptance examples."
  ],
  "mobile": [
    "MOBILE DEVELOPMENT",
    "Scope a Useful Mobile Flow",
    "Choose one task for a mobile app. Define platform, audience, lifecycle assumptions, and three acceptance examples.",
    "A one-page app brief and flow sketch."
  ],
  "design": [
    "PRODUCT DESIGN",
    "Observe a User Problem",
    "Choose an everyday task. Observe its context with consent and list evidence, assumptions, constraints, and a desired outcome.",
    "An anonymized context map and problem brief."
  ],
  "product": [
    "PRODUCT MANAGEMENT",
    "Frame the Right Problem",
    "Describe one real user, their context, the evidence for a problem, and a desired outcome. Separate observations from assumptions.",
    "A problem statement with user, context, evidence, and outcome."
  ],
  "data": [
    "DATA & ANALYTICS",
    "Frame an Analytical Decision",
    "Choose an openly available or synthetic dataset and a decision question. Define audience, scope, success criteria, and what data cannot answer.",
    "An analysis brief with a decision question and limits."
  ],
  "ai": [
    "AI & MACHINE LEARNING",
    "Define a Safe Learning Task",
    "Choose a low-stakes prediction problem using open or synthetic data. Define the target, error costs, intended use, and prohibited uses.",
    "A task specification and initial risk assessment."
  ]
};
document.querySelectorAll('[data-domain]').forEach(button => button.addEventListener('click', () => {
  document.querySelectorAll('[data-domain]').forEach(b => b.setAttribute('aria-pressed', String(b === button)));
  const [domain, title, description, output] = missions[button.dataset.domain];
  document.querySelector('#domain-label').textContent = domain; document.querySelector('#mission-title').textContent = title;
  document.querySelector('#mission-description').textContent = description; document.querySelector('#mission-output').textContent = output;
}));
