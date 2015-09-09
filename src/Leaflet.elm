module Leaflet where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as Json exposing ((:=))
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
    [ div [style myStyle, id "map"] []
    , div [] [text ("Lat: " ++ toString(model.lat))]
    , div [] [text ("Lng: " ++ toString(model.lng))]
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
