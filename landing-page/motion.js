import { animate, hover, inView, stagger } from 'motion';

// Progressive enhancement: the complete page remains readable without JavaScript.
const preference = window.matchMedia('(prefers-reduced-motion: reduce)');
const activeAnimations = new Set();
const cleanups = [];
const originalStyles = new Map();
const ease = [0.22, 1, 0.36, 1];

function play(target, keyframes, options = {}) {
  const elements = typeof target === 'string'
    ? [...document.querySelectorAll(target)]
    : Array.isArray(target) ? target : [target];
  if (!elements.length) return;
  for (const element of elements) {
    if (!originalStyles.has(element)) {
      originalStyles.set(element, element.getAttribute('style'));
    }
  }
  const controls = animate(elements, keyframes, options);
  activeAnimations.add(controls);
  Promise.resolve(controls).then(() => activeAnimations.delete(controls));
  return controls;
}

function reveal(element, delay = 0) {
  return play(element, { opacity: [0, 1], y: [22, 0] }, {
    duration: 0.65, ease, delay,
  });
}

function stopMotion() {
  cleanups.splice(0).forEach(cleanup => cleanup());
  activeAnimations.forEach(animation => animation.stop());
  activeAnimations.clear();
  for (const [element, style] of originalStyles) {
    element.getAnimations().forEach(animation => animation.cancel());
    if (style === null) element.removeAttribute('style');
    else element.setAttribute('style', style);
  }
  originalStyles.clear();
  document.documentElement.classList.remove('motion-enabled');
}

function startMotion() {
  stopMotion();
  if (preference.matches) return;
  document.documentElement.classList.add('motion-enabled');

  const heroItems = [...document.querySelector('.hero-copy').children];
  play(heroItems, { opacity: [0, 1], y: [24, 0] }, {
    duration: 0.8, delay: stagger(0.09), ease,
  });
  play('.phone', {
    opacity: [0, 1],
    transform: ['translateY(28px) rotate(11deg)', 'translateY(0) rotate(7deg)'],
  }, { duration: 1.1, delay: 0.12, ease });
  play('.floating', { opacity: [0, 1] }, {
    duration: 0.8, delay: stagger(0.16, { startDelay: 0.45 }), ease,
  });
  // Finite decorative movement finishes within five seconds.
  play('.needle', { transform: ['rotate(-20deg)', 'rotate(50deg)', 'rotate(38deg)'] }, {
    duration: 2.4, delay: 0.5, ease,
  });
  play('.spark', { opacity: [0, 1], scale: [0.7, 1] }, {
    duration: 0.9, delay: stagger(0.15, { startDelay: 0.5 }), ease,
  });

  const sections = '.manifesto-inner, .section-head, .directions .wrap > h2, '
    + '.preview > div:first-child, .roadmap-example, .faq > div:first-child, '
    + '.questions, .closing .wrap';
  cleanups.push(inView(sections, element => { reveal(element); }, { amount: 0.15 }));
  for (const selector of ['.steps article', '.domain-grid > div']) {
    document.querySelectorAll(selector).forEach((element, index) => {
      cleanups.push(inView(element, () => { reveal(element, (index % 3) * 0.08); }, {
        amount: 0.2,
      }));
    });
  }
  cleanups.push(hover('.button, .nav-cta', element => {
    const animation = play(element, { y: -3, scale: 1.025 }, {
      type: 'spring', stiffness: 350, damping: 24,
    });
    return () => {
      animation?.stop();
      play(element, { y: 0, scale: 1 }, { type: 'spring', stiffness: 350, damping: 24 });
    };
  }));
  // Keep anchor destinations and keyboard-focused content immediately readable.
  const showFocusedContent = event => {
    let element = event.target;
    while (element instanceof HTMLElement) {
      element.getAnimations().forEach(animation => animation.finish());
      element = element.parentElement;
    }
  };
  document.addEventListener('focusin', showFocusedContent);
  cleanups.push(() => document.removeEventListener('focusin', showFocusedContent));
}

preference.addEventListener('change', startMotion);
startMotion();
window.addEventListener('pagehide', stopMotion);
window.addEventListener('pageshow', event => { if (event.persisted) startMotion(); });
