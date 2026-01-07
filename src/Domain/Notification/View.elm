module Domain.Notification.View exposing (..)

import Msg exposing (Msg(..))
import Domain.Notification.Model exposing (Model)

import Html exposing (..)
import Html.Attributes exposing (..)

maybeViewNotification : Maybe Model -> Html Msg
maybeViewNotification notification =
    case notification of
        Just note -> 
            div
                [ class "notification-toast"
                , style "background" "#f59e0b"
                , style "color" "#0b1220"
                , style "padding" "16px 24px"
                , style "border-radius" "8px"
                , style "font-weight" "bold"
                , style "box-shadow" "0 4px 12px rgba(0,0,0,0.3)"
                , style "pointer-events" "auto"
                , style "width" "300px"
                ]
                [ div [ style "font-size" "12px", style "text-transform" "uppercase", style "opacity" "0.8" ] [ text "Wahoo!" ]
                , div [ style "font-size" "16px" ] [ text note.message ]
                ]
        Nothing ->
            div
                [ class "notification-toast"
                , style "background" "#0b1220"
                , style "color" "#0b1220"
                , style "padding" "16px 24px"
                , style "border-radius" "8px"
                , style "font-weight" "bold"
                , style "box-shadow" "0 4px 12px rgba(0,0,0,0.3)"
                , style "pointer-events" "auto"
                , style "width" "300px"
                ]
                [ div [ style "font-size" "12px", style "text-transform" "uppercase", style "opacity" "0.8" ] [ text "." ]
                , div [ style "font-size" "16px" ] [ text "." ]
                ]