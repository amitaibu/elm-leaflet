"use strict";function markerEvents(e){e.on("click",function(e){elmApp.ports.markerEvents.send(!0)})}function addMap(){var e=L.map("map").setView([51.505,-.09],10);return L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6IjZjNmRjNzk3ZmE2MTcwOTEwMGY0MzU3YjUzOWFmNWZhIn0.Y8bhBaUMqFiPrDRW9hieoQ",{maxZoom:10,id:"mapbox.streets"}).addTo(e),e}var elmApp=Elm.fullscreen(Elm.Main,{markerEvents:!1}),mapEl=void 0,markerEl=void 0,defaultIcon=L.icon({iconRetinaUrl:"default@2x.2cda24a8.png",iconSize:[35,46]}),selectedIcon=L.icon({iconRetinaUrl:"selected@2x.c4402371.png",iconSize:[35,46]});elmApp.ports.setMarker.subscribe(function(e){mapEl=mapEl||addMap(),markerEl?markerEl.setLatLng([e.lat,e.lng]):(markerEl=L.marker([e.lat,e.lng]).addTo(mapEl),markerEvents(markerEl)),markerEl.setIcon(e.selected?selectedIcon:defaultIcon)});