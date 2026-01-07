module Main exposing (main)

import Domain.Achievement.Model exposing (AchievementKind(..))
import Model exposing (Model, config)
import Msg exposing (Msg(..))
import Update exposing (update)
import View exposing (view)
import Storage

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Time
import Storage exposing (loadRequest)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Time.every (1000 / config.hz) Tick
        , onKeyDown (Decode.map keyToMsg (Decode.field "key" Decode.string))
        , Time.every 5000 (\_ -> AutoSave)
        , Storage.loadResponse LoadedGame
        ]


keyToMsg : String -> Msg
keyToMsg key =
    KeyPressed key


init : () -> ( Model, Cmd msg )
init _ = ( Model.modelInit (), Storage.loadRequest () )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }