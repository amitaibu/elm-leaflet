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
  { x : Float
  , y : Float
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
  = IncrementX Float
  | Tick


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    IncrementX increment ->
      ( {model | x <- (model.x + increment)}
      , Effects.none
      )

    Tick ->
      let
        (model', _) = update (IncrementX 0.1) model
      in
        (model', Effects.batch [tick])

-- VIEW

(=>) = (,)

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [style myStyle, id "map"] []
    , div [] [text "Leaflet"]
    , div [] [text ("X: " ++ toString(model.x))]
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
