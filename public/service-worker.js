/**
 * SvaraPrana - Service Worker
 * Provides offline resilience, cache-first strategy for static assets,
 * and background notification handling for Caregiver Peace-of-Mind alerts.
 */

const CACHE_NAME = 'svaraprana-v2.0.0';
const STATIC_ASSETS = [
  '/',
  '/static/css/main.css',
  '/static/css/animations.css',
  '/static/css/responsive.css',
  '/static/js/app.js',
  '/static/js/dsp-engine.js',
  '/static/js/telecom-sim.js',
  '/static/js/data-store.js',
  '/static/manifest.webmanifest'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS).catch((err) => {
        console.warn('Non-fatal SW cache pre-fetch:', err);
      });
    })
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      );
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  // Always fetch fresh for API requests
  if (event.request.url.includes('/api/')) {
    event.respondWith(fetch(event.request));
    return;
  }

  event.respondWith(
    caches.match(event.request).then((cached) => {
      return cached || fetch(event.request).then((response) => {
        if (!response || response.status !== 200 || response.type !== 'basic') {
          return response;
        }
        const cloned = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, cloned));
        return response;
      });
    }).catch(() => {
      return caches.match('/');
    })
  );
});

// Caregiver push notification simulation
self.addEventListener('push', (event) => {
  const data = event.data ? event.data.json() : {
    title: 'SvaraPrana Care Bridge',
    body: 'Morning Chai Check complete for Shrimati Saraswati. Vitality: Optimal (88/100).'
  };

  event.waitUntil(
    self.registration.showNotification(data.title, {
      body: data.body,
      icon: '/static/assets/icons/icon-192.svg',
      badge: '/static/assets/icons/icon-192.svg',
      vibrate: [200, 100, 200],
      tag: 'svaraprana-caregiver-alert'
    })
  );
});
