module Domain.Store.Update exposing (..)

import Domain.Store.Msg exposing (Msg(..))
import Domain.Store.Model exposing (Model)
import Domain.Store.Item exposing (ItemId(..))
import Model exposing (config)
import Domain.Store.Utils exposing (calculateCost, calculatePps, getOwnedQty, getItemPps)

updateStore : Msg -> Model -> Model
updateStore msg model = 
    case msg of
        StoreClickPoop ->
            { model 
                | poop = model.poop + model.clickPower
                , totalpoop = model.totalpoop + model.clickPower 
            } 
        StoreTick ->
            let
                poopPerTick = model.poopPerSecond / config.hz
            in
            { model
                | poop = model.poop + poopPerTick
                , totalpoop = model.totalpoop + poopPerTick
            }
        BuyItem id ->
            let
                cost = model.items
                    |> List.filter (\i -> i.id == id)
                    |> List.head
                    |> Maybe.map calculateCost 
                    |> Maybe.withDefault 0
                canAfford = model.poop >= cost
            in
            if not canAfford then
                model
            else
                let
                    itemsWithNewQty =
                        List.map 
                            (\i -> if i.id == id then { i | qty = i.qty + 1 } else i) 
                            model.items

                    -- pre-calculate
                    owned = getOwnedQty itemsWithNewQty

                    -- update pps
                    finalItems =
                        List.map (\i -> { i | curPps = getItemPps i owned }) itemsWithNewQty
                in
                { model
                    | poop = model.poop - cost
                    , items = finalItems
                    , poopPerSecond = calculatePps finalItems
                }
        -- KeyPressed "k" -> 
        --     { model | poopPerSecond = model.poopPerSecond * 1.5 + 1 }
        -- KeyPressed "x" -> 
        --     { model 
        --         | items = model.items
        --             |> List.map ( \i -> { i | qty = 100 } )
        --     }
        KeyPressed _ -> 
            model