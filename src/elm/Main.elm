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
    , inputs = [Signal.map Leaflet.ToggleMarker selectMarker]
    }

main =
  app.html

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

-- interactions with Leaflet
port mapManager : Signal Leaflet.Model
port mapManager = app.model

port selectMarker : Signal (Maybe Int)
