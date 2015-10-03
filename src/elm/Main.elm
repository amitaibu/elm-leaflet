module Main where

import Effects exposing (Never)
import Leaflet exposing (init, update, view, Marker)
import StartApp
import Task


app =
  StartApp.start
    { init = Leaflet.init
    , update = Leaflet.update
    , view = Leaflet.view
    , inputs = [Signal.map Leaflet.ToggleMarker markerEvents]
    }

main =
  app.html

markerSignal : Signal Leaflet.Marker
markerSignal =
  Signal.map .marker app.model


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

-- interactions with Leaflet
port setMarker : Signal Leaflet.Marker
port setMarker = markerSignal

port markerEvents : Signal Bool
