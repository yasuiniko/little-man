module Domain.Notification.View exposing (..)

import Msg exposing (Msg(..))
import Domain.Notification.Model exposing (Notification)

import Html exposing (..)
import Html.Attributes exposing (..)

-- viewNotificatios : Model -> Html Msg
-- viewNotifications model =
--     div
--         [ style "position" "fixed"
--         , style "bottom" "24px"
--         , style "right" "24px"
--         , style "display" "flex"
--         , style "flex-direction" "column"
--         , style "gap" "12px"
--         , style "pointer-events" "none" -- Allows clicking through the empty area
--         , style "z-index" "1000"
--         ]
--         (List.map viewSingleNotification model.notifications)


maybeViewNotification : Maybe Notification -> Html Msg
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
                [ div [ style "font-size" "12px", style "text-transform" "uppercase", style "opacity" "0.8" ] [ text "aoeuthsaoeetnohuaoseuhaetnosuheoatnu" ]
                , div [ style "font-size" "16px" ] [ text "tanhoenstheonueoahnuosahutensoahntuhaontsuheoatnstehutonasuhentoasuheoants" ]
                ]