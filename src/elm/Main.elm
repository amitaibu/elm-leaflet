module Main where

import Effects exposing (Never)
import Leaflet exposing (init, update, view)
import StartApp
import Task


app =
  StartApp.start
    { init = Leaflet.init
    , update = Leaflet.update
    , view = Leaflet.view
    , inputs = []
    }


main =
  app.html

latSignal : Signal Float
latSignal =
  Signal.map .lat app.model

port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

-- interactions with Leaflet
port setMarker : Signal Float
port setMarker = latSignal

port toggleMap : Signal Bool
port toggleMap = Signal.map .showMap app.model
