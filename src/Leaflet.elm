module Leaflet where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick, targetValue)
import Http
import Json.Decode as Json exposing ((:=))
import String exposing (length)


-- MODEL

type alias Marker =
  { x : Float
  , y : Float
  }



type alias Model =
  { marker : Marker
  }


initialModel : Model
initialModel =
  Model (Marker 51.5 -0.09)

init : (Model, Effects Action)
init =
  ( initialModel
  , Effects.none
  )


-- UPDATE

type Action
  = IncrementX Int


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    IncrementX x ->
      (model, Effects.none)

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [style myStyle, id "map"] []
    , div [] [text "Leaflet"]
    ]



myStyle : List (String, String)
myStyle =
    [ ("width", "600px")
    , ("height", "400px")
    -- , ("id", "map")
    ]

-- EFFECTS
