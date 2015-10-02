"use strict";

var elmApp = Elm.fullscreen(Elm.Main, {});

var mapEl = undefined;

var marker = undefined;


elmApp.ports.setMarker.subscribe(function(model) {
  if (!mapEl) {
    return;
  }

  if (!marker) {
    marker = L.marker([model, -0.09]).addTo(mapEl);
  }
  else {
    marker.setLatLng([model, -0.09]);
  }
});

elmApp.ports.toggleMap.subscribe(function(show) {
  if (show && !mapEl) {
    mapEl = addMap();
  }
  else if (!show && !!mapEl) {
    mapEl.remove();
    mapEl = undefined;
    marker = undefined;
  }



});

function addMap() {
  // Leaflet
  var mapEl = L.map('map').setView([51.505, -0.09], 13);

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IjZjNmRjNzk3ZmE2MTcwOTEwMGY0MzU3YjUzOWFmNWZhIn0.Y8bhBaUMqFiPrDRW9hieoQ', {
    maxZoom: 18,
    id: 'mapbox.streets'
  }).addTo(mapEl);

  return mapEl;
}
