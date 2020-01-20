// Service Worker Install
self.addEventListener('install', function(e) {
  e.waitUntil(
    caches.open('whatif.v1').then(function(cache) {
      return cache.addAll(['/offline.html']);
    }),
  );
});

// Serve Cache
self.addEventListener('fetch', function(event) {
  console.debug('fetch cache', event.request.url);

  event.respondWith(
    caches
      .match(event.request)
      .then(function(response) {
        // disable cache...
        return fetch(event.request);
        // return response || fetch(event.request);
      })
      .catch(function(error) {
        console.debug('serve offline cache');
        // When the cache is empty and the network also fails,
        // we fall back to a generic "Offline" page.
        return caches.match('/offline.html');
      }),
  );
});
