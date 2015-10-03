module Leaflet where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as Json exposing ((:=))
import String exposing (length)
import Task exposing (map)

import Debug


-- MODEL

type alias Marker =
  { lat: Float
  , lng : Float
  , selected : Bool
  }

type alias Model =
  { marker : Marker
  , showMap : Bool
  }


initialMarker : Marker
initialMarker =
  { lat = 51.5
  , lng = -0.09
  , selected = False
  }


initialModel : Model
initialModel =
  { marker = initialMarker
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
  | ToggleMarker Bool


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    IncrementLat val ->
      let
        marker = model.marker
        marker' = { marker | lat <- marker.lat + val }
      in
        ( { model | marker <- marker' }
        , Effects.none
        )

    IncrementLng val ->
      let
        marker = model.marker
        marker' = { marker | lng <- marker.lng + val }
      in
        ( { model | marker <- marker' }
        , Effects.none
        )

    Tick ->
      let
        (model', _) = update (IncrementLat 0.001) model
        (model'', _) = update (IncrementLng 0.001) model'
      in
        (model'', Effects.none)

    Toggle ->
      ( { model | showMap <- (not model.showMap) }
      , Effects.none
      )

    ToggleMarker val ->
      let
        marker = model.marker
        marker' = { marker | selected <- not model.marker.selected }
      in
      ( { model | marker <- marker' }
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
    , div [] [text ("Lat: " ++ toString(model.marker.lat))]
    , div [] [text ("Lng: " ++ toString(model.marker.lng))]
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
