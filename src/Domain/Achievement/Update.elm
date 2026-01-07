module Domain.Achievement.Update exposing (..)

import Msg exposing (Msg(..))
import Domain.Achievement.Model exposing (Model)

updateAchievements : Msg -> Model -> Model
updateAchievements msg model = 
    case msg of
        Hover ach ->
            let 
                modelWithHover =
                    { model | hoveredAchievement = Just ach }
            in 
            modelWithHover

        Unhover ->
            let
                modelWithoutHover = { model | hoveredAchievement = Nothing }
            in
            modelWithoutHover
        AutoSave ->
            model
        Clickpoop ->
            model
        Tick _ ->
            model
        BuyItem _ ->
            model
        KeyPressed _ -> 
            model
        LoadedGame _ ->
            model
        RequestReset -> 
            model
        CancelReset -> 
            model
        ConfirmReset -> 
            model



