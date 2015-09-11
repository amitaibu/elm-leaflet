module Leaflet where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as Json exposing ((:=))
import Json.Encode exposing (..)
import String exposing (length)
import Task exposing (map)


-- MODEL

type alias Model =
  { lat : Float
  , lng : Float
  }


initialModel : Model
initialModel =
  Model 51.5 -0.09

init : (Model, Effects Action)
init =
  ( initialModel
  , Effects.batch [tick]
  )


-- UPDATE

type Action
  = IncrementLat Float
  | IncrementLng Float
  | Tick


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    IncrementLat increment ->
      ( {model | lat <- (model.lat + increment)}
      , Effects.none
      )

    IncrementLng increment ->
      ( {model | lng <- (model.lng + increment)}
      , Effects.none
      )

    Tick ->
      let
        (model', _) = update (IncrementLat 0.001) model
        (model'', _) = update (IncrementLng 0.001) model'
      in
        (model'', Effects.batch [tick])

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ Html.node "leaflet-map" [style myStyle]
      [
        Html.node "leaflet-marker" (markerProperties model) []
      ]
    , div [] [text ("Lat: " ++ toString(model.lat))]
    , div [] [text ("Lng: " ++ toString(model.lng))]
    ]

mapProperties : List (Attribute)
mapProperties =
  [ property "zoom" (Json.Encode.string "13")
  ]


markerProperties : Model -> List (Attribute)
markerProperties model =
  [ property "latitude" (Json.Encode.string (toString(model.lat)))
  , property "longitude" (Json.Encode.string (toString(model.lng)))
  , property "title" (Json.Encode.string "Marker!")
  ]

myStyle : List (String, String)
myStyle =
    [ ("width", "600px")
    , ("height", "400px")
    ]

-- EFFECTS

tick : Effects Action
tick =
  Task.sleep (1 * 1000)
    |> Task.map (\_ -> Tick)
    |> Effects.task
