"use strict";

var elmApp = Elm.fullscreen(Elm.Main, {markerEvents: false});

// Maintain the map and marker state.
var mapEl = undefined;
var markerEl = undefined;

var defaultIcon = L.icon({
  iconRetinaUrl: 'default@2x.png',
  iconSize: [35, 46]
});

var selectedIcon = L.icon({
  iconRetinaUrl: 'selected@2x.png',
  iconSize: [35, 46]
});

elmApp.ports.setMarker.subscribe(function(marker) {
  mapEl = mapEl || addMap();

  if (!markerEl) {
    markerEl = L.marker([marker.lat, marker.lng]).addTo(mapEl);
    markerEvents(markerEl);
  }
  else {
    markerEl.setLatLng([marker.lat, marker.lng]);
  }

  // Set the marker's icon.
  markerEl.setIcon(!!marker.selected ? selectedIcon : defaultIcon);
});

/**
 * Send marker click event to Elm.
 */
function markerEvents(markerEl) {
  markerEl.on('click', function(e) {
    elmApp.ports.markerEvents.send(true);
  });
}



function addMap() {
  // Leaflet
  var mapEl = L.map('map').setView([51.505, -0.09], 10);

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IjZjNmRjNzk3ZmE2MTcwOTEwMGY0MzU3YjUzOWFmNWZhIn0.Y8bhBaUMqFiPrDRW9hieoQ', {
    maxZoom: 10,
    id: 'mapbox.streets'
  }).addTo(mapEl);

  return mapEl;
}
