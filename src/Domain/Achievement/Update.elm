module Domain.Achievement.Update exposing (..)

import Domain.Achievement.Msg exposing (Msg(..))
import Domain.Achievement.Model exposing (Model)

updateAchievements : Msg -> Model -> Model
updateAchievements msg model = 
    case msg of
        Hover ach ->
            { model | hoveredAchievement = Just ach }

        Unhover ->
             { model | hoveredAchievement = Nothing }



