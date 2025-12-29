module UI.StatBox exposing (statBox)

import Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)

statBox : String -> String -> Html Msg
statBox label value =
    div [ style "background" "rgba(0,0,0,0.3)", style "padding" "12px", style "border-radius" "8px" ]
        [ div [ style "font-size" "12px", style "color" "#94a3b8", style "margin-bottom" "4px" ] [ text label ]
        , div [ style "font-size" "20px", style "font-weight" "bold" ] [ text value ]
        ]