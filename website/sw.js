// Service Worker

const CACHE_NAME = 'dario-portfolio-v5';

const FILES_TO_CACHE = [
    '/',
    '/index.html',
    '/privacy-policy.html',
    '/manifest.json',
    '/css/style.min.css',
    '/js/main.js',
    '/js/theme.js',
    '/js/service-worker-registration.js',
    '/fonts/Inter/inter-v20-latin-700.woff2',
    '/fonts/Inter/inter-v20-latin-regular.woff2',
    '/fonts/Inter/inter-v20-latin-500.woff2',
    '/fonts/Inter/inter-v20-latin-600.woff2',
    '/icons/icon-192.png',
    '/icons/icon-512.png',
    '/favicon.svg',
    '/screenshots/desktop.png',
    '/screenshots/mobile.png'
];

self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(FILES_TO_CACHE))
    );
});

self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames
                    .filter(cacheName => cacheName !== CACHE_NAME)
                    .map(cacheName => caches.delete(cacheName))
            );
        })
    );
});

self.addEventListener('fetch', event => {
    if (event.request.method !== 'GET') {
        return;
    }

    event.respondWith(
        caches.match(event.request)
            .then(response => {
                return response || fetch(event.request);
            })
            .catch(() => {
                if (event.request.mode === 'navigate') {
                    return caches.match('/index.html');
                }
            })
    );
});
