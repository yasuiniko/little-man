module Domain.Achievement.Update exposing (..)

import Msg exposing (Msg(..))
import Domain.Achievement.Model exposing (Model)

updateAchievements : Msg -> Model -> Model
updateAchievements msg model = 
    case msg of
        CheckAchievements _ -> 
            model
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
        Clickpoop ->
            model
        Tick _ ->
            model
        BuyItem _ ->
            model
        KeyPressed _ -> 
            model
        AddNotification _ ->
            model



