module Domain.Achievement.View exposing (viewAchievement)

import Model exposing (config)
import Msg as MainMsg
import Domain.Achievement.Msg exposing (Msg(..))
import Domain.Achievement.Model exposing (Achievement, AchievementKind(..), Model)
import Html exposing (Html, div, text, Attribute, img)
import Html.Attributes exposing (style, src)
import Html.Events exposing (onMouseEnter, onMouseLeave)


-- STYLES
achievementBoxStyle : Bool -> List (Attribute MainMsg.Msg)
achievementBoxStyle unlocked =
    [ style "position" "relative"
    , style "width" "40px"
    , style "height" "40px"
    , style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "center"
    , style "cursor" "pointer"
    , style "border-radius" "4px"
    , style "background" config.accent
    , style "opacity" (if unlocked then "1" else "0.2")
    ]

trophyStyle : Bool -> List (Attribute MainMsg.Msg)
trophyStyle unlocked =
    [ style "font-size" "20px"
    , style "display" "flex"
    , style "align-items" "center"
    , style "justify-content" "center"
    ]

tooltipStyle : Bool -> List (Attribute MainMsg.Msg)
tooltipStyle isVisible =
    [ style "position" "absolute"
    , style "top" "110%"
    , style "left" "50%"
    , style "transform"
        (if isVisible then
            "translateX(-50%) translateY(0)"
         else
            "translateX(-50%) translateY(-4px)"
        )
    , style "opacity" (if isVisible then "1" else "0")
    , style "transition" "opacity 120ms ease-out, transform 120ms ease-out"
    , style "background" "#222"
    , style "color" "white"
    , style "padding" "6px 8px"
    , style "border-radius" "4px"
    , style "font-size" "12px"
    , style "white-space" "nowrap"
    , style "z-index" "10"
    , style "pointer-events" "none"
    ]

-- VIEWS
trophyIcon : Achievement -> Html MainMsg.Msg
trophyIcon ach =
    div (trophyStyle ach.unlocked)
        [ img
            [ src "https://placehold.co/200x200/8B4513/FFF?text=Yay!"
            , style "width" "32px"
            , style "height" "32px"
            ]
            [] 
        ]

tooltipView : Bool -> Achievement -> Html MainMsg.Msg
tooltipView isHovered ach =
    div (tooltipStyle isHovered)
        [ if ach.unlocked then
              text (ach.name ++ " — " ++ ach.description)
          else
              text ach.name
        ]

viewAchievement : Model -> Achievement -> Html MainMsg.Msg
viewAchievement model ach =
    let
        isHovered =
            model.hoveredAchievement == Just ach
    in
    div
        (achievementBoxStyle ach.unlocked
            ++ [ onMouseEnter (MainMsg.AchievementMsg (Hover ach))
               , onMouseLeave (MainMsg.AchievementMsg Unhover)
               ]
        )
        [ trophyIcon ach
        , tooltipView isHovered ach
        ]