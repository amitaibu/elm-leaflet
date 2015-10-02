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
  , showMap : Bool
  }


initialModel : Model
initialModel =
  { lat = 51.5
  , lng = -0.09
  , showMap = True
  }

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
  | Toggle


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

    Toggle ->
      ( {model | showMap <- (not model.showMap)}
      , Effects.none
      )

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  let
    mapEl =
      if model.showMap
        then div [ style myStyle, id "map" ] []
        else div [ id "map" ] []
  in
  div []
    [ mapEl
    , div [] [text ("Lat: " ++ toString(model.lat))]
    , div [] [text ("Lng: " ++ toString(model.lng))]
    , button [ onClick address Toggle ] [ text "Toggle Map" ]
    , div [] [ text ("Toggle state:" ++ toString(model.showMap))]
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
