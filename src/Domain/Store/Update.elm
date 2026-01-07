module Domain.Store.Update exposing (..)

import Msg exposing (Msg(..))
import Domain.Store.Model exposing (Model)
import Domain.Store.Item exposing (ItemId(..))
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
        -- KeyPressed "k" -> 
        --     { model | poopPerSecond = model.poopPerSecond * 1.5 + 1 }
        -- KeyPressed "x" -> 
        --     let
        --         updatedItems = List.map ( \i -> { i | qty = 65 } ) model.items

        --         updatedModel = { model | items = updatedItems, poop = max (15 * 1.15^ 65 + 1) model.poop }
        --     in
        --         updateStore (BuyItem Cursor) updatedModel
        AchievementMsg _ ->
            model
        AutoSave -> 
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