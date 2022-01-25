// Adapted from the following examples:
// https://codepen.io/iangilman/pen/BpwBJe
// https://codepedia.info/detect-browser-in-javascript
// https://stackoverflow.com/questions/56216348/compare-two-images-using-pixelmatch

let imageIds = [
  // https://www.artic.edu/artworks/260219
  '70a5844c-019d-b645-f299-817aecbcfc9e',

  // https://www.artic.edu/artworks/258555
  '23842bbd-f0ea-2726-e87b-b9a6d80b6e87',

  // https://www.artic.edu/artworks/192885
  'fb06417d-c3b5-cb00-4e2a-fcff0bcc3db8',

  // https://www.artic.edu/artworks/83642
  'f9932dea-7999-ea96-fcab-965e027051c2',

  // https://www.artic.edu/artworks/100261
  '7135c1c1-f734-7a5e-e33b-714d3b776718',

  // https://www.artic.edu/artworks/214982
  '68e3a839-328f-314d-1a1a-be6bb0e4b304',

  // https://www.artic.edu/artworks/180574
  '5f32d5f0-3548-1059-f91c-3f94f0f35db3',

  // https://www.artic.edu/artworks/157158
  '8eec8935-b7c3-620e-b633-3e39fbf057af',
];

imageIds.forEach((imageId) => {
  const img = document.createElement('img');
  img.src = 'images/before/' + imageId + '.jpg';
  img.dataset.imageId = imageId;
  img.addEventListener('click', function(event) {
    openImage(event.srcElement.dataset.imageId);
  });
  document.getElementById('image-selector').append(img);
});

let notification = document.querySelector('.notification');

function checkBrowser() {
  let userAgent = navigator.userAgent;
  let browserName;

  if (userAgent.match(/chrome|chromium|crios/i)) {
    browserName = "chrome";
  } else if (userAgent.match(/firefox|fxios/i)) {
    browserName = "firefox";
  } else if (userAgent.match(/safari/i)) {
    browserName = "safari";
  } else if (userAgent.match(/opr\//i)) {
    browserName = "opera";
  } else if (userAgent.match(/edg/i)) {
    browserName = "edge";
  }

  if (browserName !== 'firefox') {
    return 'Using Firefox is recommended.';
  }
}

function checkPixelRatio() {
  var ratio = 0;

  if (window.devicePixelRatio !== undefined) {
    ratio = window.devicePixelRatio;
  }

  if (ratio != 1) {
    return 'Using a retina screen or setting the browser zoom to something other than 100% may affect results.'
  }
}

function checkEverything() {
  let warning = checkBrowser() || checkPixelRatio();
  if (warning) {
    notification.innerText = warning;
    notification.classList.remove('notification--hidden');
  } else {
    notification.classList.add('notification--hidden');
  }
}

window.addEventListener('resize', checkEverything);
checkEverything();

let viewers = [];

let lastPan = null;
let leadingViewerId = null;
let leadingViewer = null;

for (let i=0; i < 3; i++) {
  let viewer = OpenSeadragon({
    id: 'viewer' + i,
    imageSmoothingEnabled: false,
    smoothTileEdgesMinZoom: Infinity,
    maxZoomPixelRatio: Infinity,
    constrainDuringPan: true,
    zoomPerScroll: 2,
    animationTime: 0,
    opacity: 1,
    prefixUrl: 'https://openseadragon.github.io/openseadragon/images/',
  });

  function resetZoom(event) {
    let viewport = event.eventSource.viewport;
    let minZoom = viewport.imageToViewportZoom(1.0);
    viewport.zoomTo(minZoom);
    viewport.minZoomLevel = minZoom;
    viewport.maxZoomLevel = minZoom * 8;
  }

  viewer.addHandler('open', resetZoom);
  viewer.addHandler('resize', resetZoom);

  viewer.addHandler('pan', (event) => {
    lastPan = event;
  });

  viewer.addHandler('canvas-drag-end', (event) => {
    let viewport = event.eventSource.viewport;
    let image = event.eventSource.world.getItemAt(0);

    let image_center = viewport.viewportToImageCoordinates(lastPan.center);
    image_center.x = image_center.x - Math.round(image_center.x, 0);
    image_center.y = image_center.y - Math.round(image_center.y, 0);

    let new_coords = viewport.imageToViewportCoordinates(image_center);

    viewers.forEach((viewer) => {
      let image = viewer.world.getItemAt(0);
      if (image) {
        image.setPosition(new_coords, true);
      }
    });
  });

  let isSyncing = false;

  let syncViewers = (event) => {
    let currentViewer = event.eventSource;

    if (currentViewer.isSyncing) {
      return;
    }

    let otherViewers = viewers.filter((viewer) => {
      return viewer.id != currentViewer.id;
    })

    otherViewers.forEach((viewer) => {
      viewer.isSyncing = true;
      viewer.viewport.zoomTo(currentViewer.viewport.getZoom(), null, true);
      viewer.viewport.panTo(currentViewer.viewport.getCenter(), true);
      viewer.isSyncing = false;
    });
  }

  viewer.addHandler('zoom', syncViewers);
  viewer.addHandler('pan', syncViewers);

  viewers.push(viewer);
}

openImage(imageIds[0]);

function openImage(imageId) {
  let imageUrls = [
    'images/before/' + imageId + '.jpg',
    'images/after/' + imageId + '.jpg',
  ];

  var cnvBeforePromise = getCanvasFromImageUrl(imageUrls[0]);
  var cnvAfterPromise = getCanvasFromImageUrl(imageUrls[1]);

  var promises = Promise.all([cnvBeforePromise, cnvAfterPromise]);

  promises.then(run);

  function run(data) {
    var cnvBefore = data[0];
    var cnvAfter = data[1];

    var ctxBefore = cnvBefore.getContext('2d');
    var ctxAfter = cnvAfter.getContext('2d');

    let imgDataBefore = ctxBefore.getImageData(0,0,cnvBefore.width, cnvBefore.height);
    let imgDataAfter = ctxAfter.getImageData(0,0, cnvAfter.width, cnvAfter.height);

    const height = imgDataBefore.height;
    const width = imgDataBefore.width;

    var imgDataOutput = new ImageData(width, height);

    var numDiffPixels = pixelmatch(imgDataBefore.data, imgDataAfter.data,
                                   imgDataOutput.data, width, height, {threshold: 0.025});

    let tilesSources = imageUrls.map((imageUrl) => {
      return {
        type: 'image',
        url: imageUrl,
      };
    });

    tilesSources.push({
      type: 'image',
      url: getCanvasFromImageData(imgDataOutput).toDataURL(),
    });

    for (let i=0; i < 3; i++) {
      viewers[i].open(tilesSources[i]);
    }
  }
}

// Returns a promise, so we must wait for it to resolve
function getCanvasFromImageUrl(url) {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.crossOrigin = "Anonymous";
    img.onload = () => {
      const canvas = document.createElement('canvas');
      canvas.width = img.width;
      canvas.height = img.height;
      canvas.getContext('2d').drawImage(img, 0, 0);
      return resolve(canvas);
    };
    img.onerror = (error) => reject(error);
    img.src = url;
  });
}

function getCanvasFromImageData(imgDataOutput) {
  const canvas = document.createElement('canvas');
  canvas.width = imgDataOutput.width;
  canvas.height = imgDataOutput.height;
  const ctx = canvas.getContext('2d');
  ctx.putImageData(imgDataOutput, 0, 0);
  return canvas;
}
