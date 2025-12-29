module Domain.Store.Update exposing (..)

import Msg exposing (Msg(..))
import Domain.Store.Model exposing (Model)
import Domain.Store.Utils exposing (buyItem)
import Model exposing (config)

updateStore : Msg -> Model -> Model
updateStore msg model = 
    case msg of
        Clickpoop ->
            let
                newpoop =
                    model.poop + model.clickPower

                newTotal =
                    model.totalpoop + model.clickPower
                updatedModel =
                    { model | poop = newpoop, totalpoop = newTotal } 
            in
            updatedModel
        Tick _ ->
            let
                poopPerTick =
                    model.poopPerSecond / config.hz

                -- Update resources
                modelWithResources =
                    { model
                        | poop = model.poop + poopPerTick
                        , totalpoop = model.totalpoop + poopPerTick
                    }
            in
            modelWithResources
        BuyItem id ->
            let
                updatedModel = buyItem id model
            in
            updatedModel

        Hover _ ->
            model
        Unhover ->
            model
        KeyPressed _ -> 
            model
        CheckAchievements _ -> 
            model
        AddNotification _ ->
            model

