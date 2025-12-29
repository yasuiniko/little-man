module Main exposing (main)

import Domain.Achievement.Model exposing (AchievementKind(..))
import Model exposing (Model, config)
import Msg exposing (Msg(..))
import Update exposing (update)
import View exposing (view)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Time

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every (1000 / config.hz) Tick
        , onKeyDown (Decode.map keyToMsg (Decode.field "key" Decode.string))
        ]


keyToMsg : String -> Msg
keyToMsg key =
    KeyPressed key


init : () -> ( Model, Cmd Msg )
init _ = ( Model.init (), Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }