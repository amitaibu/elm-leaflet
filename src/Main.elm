
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


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
