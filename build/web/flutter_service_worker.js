'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "d90d1accb2485b3e9cc3b6d8ccd76df8",
"assets/AssetManifest.bin.json": "a3314dcb90d177e884ae23044e91cc77",
"assets/AssetManifest.json": "29db02bbfa1a1bdeeb7e386e921e9aa8",
"assets/assets/fonts/CinzelDecorative-Bold.ttf": "a388d4f6e855b334da95b975bb30bf4d",
"assets/assets/fonts/comme-medium.ttf": "4897f8791a7fc17ae467092391b54193",
"assets/assets/fonts/Roboto-Regular.ttf": "327362a7c8d487ad3f7970cc8e2aba8d",
"assets/assets/icons/arrow.svg": "b75eaa1a2862f6c93603a6d5b31ddef6",
"assets/assets/icons/arrow_down.svg": "1ec3a3c71da1be2987cba77ae75f17ad",
"assets/assets/icons/dashboard.svg": "0a97be39356a4f1480e829db7a723a59",
"assets/assets/icons/establishment.svg": "03dce9896861eed9bab7e4d6aea5ffa3",
"assets/assets/icons/feedback.svg": "a4bb82b17dfb80b9dd2a427569757bf4",
"assets/assets/icons/menu_management.svg": "44610b897c6130e80e90ee8a796d9f4f",
"assets/assets/icons/nachos-svgrepo-com.svg": "ad89c2232a6bdf2eb5656aa783403b90",
"assets/assets/icons/order.svg": "50fe90e34dc24b52f4be6fa0f41f9d52",
"assets/assets/icons/reservation.svg": "804ebf43924af71dae5d2a2f69452d6c",
"assets/assets/icons/setting.svg": "72280b4d19a0f531d33d9e4d57b165f8",
"assets/assets/icons/Vector.svg": "57470f583ba88a27aa99c0a2a11d4dfd",
"assets/assets/images/demo/Apple%2520Pie.jpg": "a5970608cb04e8998acafd36d0d2b149",
"assets/assets/images/demo/Bacon-Cheddar-Dip.jpg": "5ae87c8ec41ead54b1c2487edc401df4",
"assets/assets/images/demo/banana%2520split.jpg": "d8a5fe6f0bd0fee72292dce6f6d69842",
"assets/assets/images/demo/Beef-Burgers.jpg": "f3d20e23fb044b43e9ed8f8ed328f5b3",
"assets/assets/images/demo/Blue%2520Berry%2520Cheese%2520Cake.jpg": "080bce980ed05bda0d88b58d3af4edd5",
"assets/assets/images/demo/Blue%2520Berry%2520Pie.jpg": "7c960e5c9051af35f96459d8af237e31",
"assets/assets/images/demo/Blue-Cheese-Dip.jpg": "a132f20d6a3362b2d32f9158185a0398",
"assets/assets/images/demo/Bread%2520Pudding.jpg": "ba497235ff2c474dd0feacbe1978b904",
"assets/assets/images/demo/buffalo-chicken-dip.jpg": "92e09cea14f112696f5909ae9eea5761",
"assets/assets/images/demo/Caeser%2520Salad.png": "b5e87f97bfa4b18ebecf3afd6fd5832b",
"assets/assets/images/demo/Calamari.jpg": "8eb9335a5a2e07b76b721d8f88fc9b84",
"assets/assets/images/demo/Caprese%2520Skewers.jpg": "f416dc8cc05d68bef0b512bfd3cac9d7",
"assets/assets/images/demo/Carbonara.jpg": "a36ae7e78567b35c40783684c1def485",
"assets/assets/images/demo/cauliflower%2520curry.jpg": "4734f18e7c0b7eca59e5005af17583d3",
"assets/assets/images/demo/Cheese%2520cake.jpg": "d8bcaa14d37320d83d38d1fbe6ff1df6",
"assets/assets/images/demo/Cherry%2520Pie.jpg": "4410ae8f81a7e087d5140b2a0495b06d",
"assets/assets/images/demo/chicken%2520wings.jpg": "46db8fd4e034a36791d69c136d56c4da",
"assets/assets/images/demo/Chocolate%2520Pudding.jpg": "5ebbd9ccade182247882a374a76643a4",
"assets/assets/images/demo/Crame%2520brulee.jpg": "45d0ab3c5602c7f00af93e8145254d3c",
"assets/assets/images/demo/eggplant-parmesan.jpg": "aea35b5ec282e90c814a8bf2c6b0fcb9",
"assets/assets/images/demo/Gelato.jpg": "ab31269ba4d5542beab2f402b1a25fd0",
"assets/assets/images/demo/greeksalad.jpg": "820e6faa223b620d647785f141780e72",
"assets/assets/images/demo/grilled%2520salmon.jpeg": "0cc3c1be86ffc2e9a3d4f6549dbbb999",
"assets/assets/images/demo/grilled%2520steak.jpg": "4ee6ce10446b1a96d35756b98e488c89",
"assets/assets/images/demo/Ice-Cream-Sundae.jpg": "a9980df99f161a9c83509196b3fe057c",
"assets/assets/images/demo/lamb%2520chops.jpg": "474d1103028e6a61fd8a23d3f0d284c6",
"assets/assets/images/demo/Lasagna.jpg": "cc99b04a8077ba45a97e91c34cb0dd56",
"assets/assets/images/demo/Lava%2520Cake.jpg": "9fd22c9f674818aab579e166cf2cd5a6",
"assets/assets/images/demo/lobster-tail.jpg": "63047253130fe079c6d5467d9902c48e",
"assets/assets/images/demo/Logo.png": "01989acb9ab137e526eaeaead51d9f6c",
"assets/assets/images/demo/Mac-Cheese.jpg": "835cd453e5914bd5669840d613fd3de7",
"assets/assets/images/demo/oysters.jpg": "1b0cf7e8180b38aff3606e496477c4f2",
"assets/assets/images/demo/pizza%2520ittaliano.png": "502ab13a7a78ff8d70769686f57a39bf",
"assets/assets/images/demo/Red%2520Wine.jpg": "c71428b69b3a5e330750a399204ff1ba",
"assets/assets/images/demo/restobg.jpg": "30ee93f8b291f688b4ddd2527bd0cc1a",
"assets/assets/images/demo/roast%2520chicken.jpg": "545a9831135a33bf3c19a3783a2d00f0",
"assets/assets/images/demo/Strawberry%2520Cake.jpg": "3c91ae791390d21ac6eb34ef6dcac5aa",
"assets/assets/images/demo/Strawberry-Balsamic-Bruschetta.jpg": "d4b15a130612dc4ee59a8d7465c2a605",
"assets/assets/images/demo/stuffed-dates.jpg": "bd0b456968fecf7435447c9c0788dd99",
"assets/assets/images/demo/tuna_steak.jpg": "663d12c6054eb76b7be0dc706fa0e513",
"assets/assets/images/demo/Vanilla%2520Pudding.jpg": "bcf10f08179cc31329d20d3233f75fba",
"assets/assets/images/demo/White%2520Wine.jpg": "6e21adae7e59f447281973fd17572cf8",
"assets/assets/lang/ar.json": "cc488e52fc410ef1802ea5f1f5469372",
"assets/assets/lang/en.json": "83e51842178fc2a97496953055914832",
"assets/assets/lang/fr.json": "0257b900fa8be10c57383438c51fd5f8",
"assets/assets/lang/tr.json": "9c1b5d1130643a7c1ec40f527463ca92",
"assets/FontManifest.json": "2a7cf8b50cae2c59886989f54c741e62",
"assets/fonts/MaterialIcons-Regular.otf": "bcfc13a6d100e4797dff879405f319fc",
"assets/NOTICES": "62bd6b99d7101ff8f29b7ed6bee1b9ab",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "b2f4dc6d2ebb1036aaba6b8bd051fe69",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "d57f29281ca9b8f834d51c387e52aa40",
"/": "d57f29281ca9b8f834d51c387e52aa40",
"main.dart.js": "dd7a9c7e5ae4254936e71dd9036e12fa",
"manifest.json": "0bd27dae9a59c3f6d82da3206613675b",
"version.json": "44c8fe400d0f766fd645ec2738fd33c0"};
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
