"use strict";

var elmApp = Elm.fullscreen(Elm.Main, {});

// Maintain the map and marker state.
var mapEl = undefined;
var markerEl = undefined;

elmApp.ports.setMarker.subscribe(function(marker) {
  mapEl = mapEl || addMap();

  if (!markerEl) {
    markerEl = L.marker([marker.lat, marker.lng]).addTo(mapEl);
  }
  else {
    markerEl.setLatLng([marker.lat, marker.lng]);
  }
});

function addMap() {
  // Leaflet
  var mapEl = L.map('map').setView([51.505, -0.09], 10);

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IjZjNmRjNzk3ZmE2MTcwOTEwMGY0MzU3YjUzOWFmNWZhIn0.Y8bhBaUMqFiPrDRW9hieoQ', {
    maxZoom: 10,
    id: 'mapbox.streets'
  }).addTo(mapEl);

  return mapEl;
}
