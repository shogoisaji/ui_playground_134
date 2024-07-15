'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "6d2422e924c27f8d065524073f45a693",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "563f26ba740147cab73799691393017e",
"version.json": "5112423804a8cd2371214e0cbc39e6c8",
"favicon.png": "3960b7140381a3eadab320ac9f629cd7",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "f3307f62ddff94d2cd8b103daf8d1b0f",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "04f83c01dded195a11d21c2edf643455",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "b392c64816c3c79d6e4b75fcf7396761",
"assets/NOTICES": "0c627bf50bf105cd9a3418b1a7900be1",
"assets/lib/pages/m_line_chart/data.json": "db69de2b76421b0f8fc12e8f49417497",
"assets/AssetManifest.bin": "f8de28088b11d22e82ebcc5c70f4e4f4",
"assets/FontManifest.json": "3ddd9b2ab1c2ae162d46e3cc7b78ba88",
"assets/AssetManifest.bin.json": "8d1b4fae490266c11f5cac748bc27a9d",
"assets/assets/thumbnails/smooth_nav.png": "29b8d3d75b5728c209d96e7018c8bccf",
"assets/assets/thumbnails/spin_overlay.png": "ddfa5b3a2ffbc748f29fcda441759709",
"assets/assets/thumbnails/volume_controller.png": "c799d2f6479b3e35a7ebc460ff6907a4",
"assets/assets/thumbnails/rive_power.png": "c15935d4687ec1c5536365b6d8067922",
"assets/assets/thumbnails/level_gauge.png": "06f0d68ad7e3613a25f00c94af03cf0d",
"assets/assets/thumbnails/stripe_animation.png": "28090c82e5beff470e50ef59cea50c57",
"assets/assets/thumbnails/deform_cloud.png": "0ebeaca525d08e70479fe60693b79183",
"assets/assets/thumbnails/follow_path.png": "fa64acf41d5d273f86c581847c171627",
"assets/assets/thumbnails/m_line_chart.png": "ddac196ee1ac612562454203f0f13f0f",
"assets/assets/thumbnails/rive_carousel.png": "ed6fd0927f4a654d3f0b0310f4b513a0",
"assets/assets/thumbnails/particle_hole.png": "dcb106617958a5337dbfb63ffad7686a",
"assets/assets/thumbnails/scaleup_nav.png": "4a00205850bc3227b069f517f3f31990",
"assets/assets/thumbnails/custom_modal.png": "56b6de4050a0546120ed0eedd696ca14",
"assets/assets/thumbnails/interactive_lottie.png": "bf5a12c90be2139a0100dc3608bc054a",
"assets/assets/rive/power.riv": "6e983beb35c151bc866e439f1ecc9640",
"assets/assets/rive/character.riv": "7f3a58c200cb36596e36203827567d6b",
"assets/assets/animated_thumbnails/smooth_nav.webp": "5fb2eb49b88ef89323840a7f32f99b54",
"assets/assets/animated_thumbnails/level_gauge.webp": "a688cdc80dc866c3e7bef9dc419859ee",
"assets/assets/animated_thumbnails/interactive_lottie.webp": "ced6960260c8c36b91f89bba666a12b7",
"assets/assets/animated_thumbnails/particle_hole.webp": "e6ad95916f1b7b1d38ef4df6a3c4f7be",
"assets/assets/animated_thumbnails/custom_modal.webp": "17c6693d2b61a1d3f320d49cd8facf51",
"assets/assets/animated_thumbnails/deform_cloud.webp": "0c66451fdfb9411dce59a10478629e28",
"assets/assets/animated_thumbnails/follow_path.webp": "affdb3fd188ee5710ad099d4c8cf96e1",
"assets/assets/animated_thumbnails/volume_controller.webp": "86795bc56f003c7d427d66370cdb0061",
"assets/assets/animated_thumbnails/m_line_chart.webp": "6c17803436c3f76ddef9cc7e04c07b10",
"assets/assets/animated_thumbnails/spin_overlay.webp": "797f80eaa92baca9801e11087566e1cc",
"assets/assets/animated_thumbnails/stripe_animation.webp": "42e3bc6eba15b3db7cb529646a5c0b15",
"assets/assets/animated_thumbnails/rive_power.webp": "e9cff64c91e3372ac35e3cdc810790fc",
"assets/assets/animated_thumbnails/scaleup_nav.webp": "a0ef6737656d7d94281518f6e62d4d8b",
"assets/assets/animated_thumbnails/rive_carousel.webp": "68d768f47bb38804dc006c84257b0f16",
"assets/assets/images/logo.png": "91b9a839385f017ba4655c41f2ac526f",
"assets/assets/images/rive_icon.svg": "457c8de2e59a0457c0fad01ad491ceba",
"assets/assets/images/character.png": "2fc8120d9aacd37583c1f99625ad02b7",
"assets/assets/lottie/send.json": "24f09688894506c9e3f4661861180359",
"assets/fonts/MaterialIcons-Regular.otf": "2de0f15d54ac406c6aa61aeb813ffe7b",
"assets/AssetManifest.json": "a4c8e4547e7f9d8a3d507d5b5b7bb7cb",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"index.html": "8584ee1311f5ebcbcb32ea688950cba4",
"/": "8584ee1311f5ebcbcb32ea688950cba4",
"main.dart.js": "d63c3158c7a219acc05a9b29a1166028"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
