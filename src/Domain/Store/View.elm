module Domain.Store.View exposing (..)

import Msg as MainMsg
import Domain.Store.Msg exposing (Msg(..))
import Domain.Store.Item exposing (Item, itemMeta)
import Domain.Store.Utils exposing (calculateCost)
import Html exposing (Html, button, div, img, span, text)
import Html.Attributes exposing (class, disabled, src, style)
import Html.Events exposing (onClick)

formatPps : Float -> String
formatPps val =
    if val < 1 then
        -- Multiplies by 1000, rounds to nearest integer, then divides back
        -- to simulate 3 decimal places
        String.fromFloat (toFloat (round (val * 1000)) / 1000)
    else if val < 10 then
        -- Multiplies by 100, rounds to nearest integer, then divides back
        -- to simulate 2 decimal places
        String.fromFloat (toFloat (round (val * 100)) / 100)
    else
        String.fromFloat (toFloat (round val))

viewStoreItem : Float -> Item -> Html MainMsg.Msg
viewStoreItem poop item =
    let
        cost = calculateCost item
        canAfford = poop >= cost

        { name, image } = itemMeta item.id
    in
    div
        [ style "background" "rgba(255,255,255,0.03)"
        , style "padding" "12px"
        , style "border-radius" "8px"
        , style "display" "flex"
        , style "justify-content" "space-between"
        , style "align-items" "center"
        ]
        [ div [ style "display" "flex", style "align-items" "center", style "gap" "12px" ]
            [ img [ src image, style "width" "48px", style "height" "48px", style "border-radius" "4px", style "object-fit" "cover" ] []
            , div []
                [ div [ style "font-weight" "bold", style "font-size" "16px" ]
                    [ text name
                    , span [ style "margin-left" "8px", style "color" "#94a3b8", style "font-size" "14px", style "font-weight" "normal" ] [ text ("x" ++ String.fromInt item.qty) ]
                    ]
                -- Added the description here
                , div [ style "font-size" "13px", style "color" "#cbd5e1", style "margin-top" "2px" ] 
                    [ text item.description ]
                , div [ style "font-size" "12px", style "color" "#94a3b8", style "margin-top" "4px" ] 
                    [ text ("+" ++ formatPps item.curPps ++ " pps") ]
                ]
            ]
        , div [ style "text-align" "right" ]
            [ div [ style "margin-bottom" "6px", style "font-size" "14px", style "color" (if canAfford then "#6ee7b7" else "#ef4444") ]
                [ text (String.fromFloat cost) ]
            , button
                [ class "btn-buy"
                , onClick (MainMsg.StoreMsg (BuyItem item.id))
                , disabled (not canAfford)
                ]
                [ text "Buy" ]
            ]
        ]