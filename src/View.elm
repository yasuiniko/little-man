module View exposing (..)

import Msg exposing (Msg(..))
import Model exposing (Model, config)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Domain.Notification.View exposing (maybeViewNotification)
import Domain.Store.View exposing (viewStoreItem)
import Domain.Store.Model as Store
import Domain.Achievement.Model as Achievement
import Domain.Achievement.View exposing (viewAchievement)
import Domain.Achievement.Utils exposing (groupAchievements)
import UI.StatBox exposing (statBox)
import Domain.Store.View exposing (viewStoreItem)
import Assets exposing (getpoopImage)

view : Model -> Html Msg
view model =
    div
        [ style "min-height" "80vh"
        , style "background" config.bgGradient
        , style "color" "#e6eef8"
        , style "font-family" "system-ui, sans-serif"
        , style "padding" "24px"
        , style "box-sizing" "border-box"
        ]
        [ globalStyles
        , div [ class "app-container" ]
            [ headerView
            , div [ class "grid-layout" ]
                [ leftPanelView model.storeModel model.achievementModel
                , rightPanelView model
                ]
            ]
        ]

globalStyles : Html Msg
globalStyles =
    node "style"
        []
        [ text """
        .app-container { max-width: 1100px; margin: 0 auto; }
        .grid-layout { display: grid; grid-template-columns: 360px 1fr; gap: 24px; }
        .panel { background: #0b1220; padding: 24px; border-radius: 12px; box-shadow: 0 6px 20px rgba(0,0,0,0.3); }
        .btn-buy { background: linear-gradient(90deg, #f59e0b, #f97316); border: none; padding: 8px 16px; border-radius: 6px; color: #061421; font-weight: bold; cursor: pointer; transition: transform 0.1s; }
        .btn-buy:active:not([disabled]) { transform: scale(0.95); }
        .btn-buy:disabled { opacity: 0.5; cursor: not-allowed; filter: grayscale(1); }
        
        /* poop Animation */
        .poop-btn { transition: transform 0.05s; user-select: none; cursor: pointer; display: block; margin: 0 auto; border-radius: 50%; box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
        .poop-btn:active { transform: scale(0.94); }
        
        /* Animations for Notifications */
        @keyframes slideIn {
            from { transform: translateX(100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        .notification-toast {
            animation: slideIn 0.3s ease-out forwards;
        }

        @media (max-width: 800px) {
            .grid-layout { grid-template-columns: 1fr; }
        }
    """
        ]


headerView : Html Msg
headerView =
    header [ style "margin-bottom" "24px", style "display" "flex", style "justify-content" "space-between", style "align-items" "center" ]
        [ h1 [ style "margin" "0", style "font-size" "24px" ] [ text "Squeeze Him" ]
        -- , div [ style "color" "#94a3b8", style "font-size" "14px" ] [ text "Spacebar to click • 10Hz Tick" ]
        ]


leftPanelView : Store.Model -> Achievement.Model -> Html Msg
leftPanelView storeModel achievementModel =
    div [ class "panel", style "text-align" "center", style "display" "flex", style "flex-direction" "column", style "gap" "24px" ]
        [
          img
            [ src (getpoopImage storeModel.poopPerSecond)
            , class "poop-btn"
            , style "width" "200px"
            , style "height" "200px"
            , onClick Clickpoop
            , alt "Giant poop"
            -- 1. PREVENT HIGHLIGHTING/SELECTION
            , style "user-select" "none"
            , style "-webkit-user-select" "none" -- Critical for Safari/Chrome
            , style "-moz-user-select" "none"    -- Firefox
            
            -- 2. PREVENT GHOST IMAGE DRAGGING
            , Html.Attributes.draggable "false"
            ]
            []

        -- Statistics
        , div [ style "display" "grid", style "grid-template-columns" "1fr 1fr", style "gap" "12px" ]
            [ statBox "poop" (String.fromInt (floor storeModel.poop))
            , statBox "Per Second" (String.fromFloat (toFloat (round (storeModel.poopPerSecond * 10)) / 10))
            ]
        
        -- Achievements Section
        , div [ style "margin-top" "12px", style "text-align" "left" ]
            [ h3 [ style "font-size" "16px", style "color" "#94a3b8", style "margin-bottom" "12px" ] 
                [ text "Achievements" ]
            
            -- MAIN CONTAINER: Flows Left-to-Right (Letters)
            , div 
                [ style "display" "flex"
                , style "flex-direction" "row" -- Forces columns side-by-side
                , style "gap" "16px"           -- Space between letter columns
                -- , style "overflow-x" "auto"    -- Scalable: Scroll if too many letters
                , style "align-items" "flex-start" 
                ]
                (List.map (viewColumn achievementModel) (groupAchievements achievementModel.achievements))
            ]
        ]

-- Helper view for a single Column (e.g., The "Cursor" Column)
viewColumn : Achievement.Model -> ( String, (List Achievement.Achievement) ) -> Html Msg
viewColumn achievementModel (categoryName, achievements)  =
    div 
        [ style "display" "flex"
        , style "flex-direction" "column" -- Forces numbers Top-to-Bottom
        , style "gap" "8px"               -- Space between achievements vertically
        , style "min-width" "20px"       -- Optional: Ensures columns don't squash
        ]
        (List.map (viewAchievement achievementModel) achievements)

rightPanelView : Model -> Html Msg
rightPanelView model =
    div [ class "panel", style "display" "flex", style "flex-direction" "column", style "gap" "16px" ]
        [ maybeViewNotification model.notification
        , h2 [ style "margin" "0", style "font-size" "20px", style "border-bottom" "1px solid rgba(255,255,255,0.1)", style "padding-bottom" "12px" ] [ text "Store" ]
        , div [ style "display" "flex", style "flex-direction" "column", style "gap" "8px" ]
            (List.map (viewStoreItem model.storeModel.poop) model.storeModel.items)
        ]


