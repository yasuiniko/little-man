module Domain.Store.Utils exposing (..)

import Dict exposing (Dict)
import Domain.Store.Model exposing (Item, Model, ItemId, itemMeta)
import Msg exposing (Msg(..))

calculatePps : List Item -> Float
calculatePps items =
    items
        |> List.map (\i -> i.curPps * toFloat i.qty)
        |> List.sum

calculateCost : Item -> Float
calculateCost item =
    toFloat (round (item.baseCost * (1.15 ^ toFloat item.qty)))


buyItem : ItemId -> Model -> Model
buyItem id model =
    let
        tryBuy item =
            if item.id == id then
                let
                    cost = calculateCost item
                in
                if model.poop >= cost then
                    Just ( { item | qty = item.qty + 1 }, cost )

                else
                    Nothing

            else
                Nothing

        found =
            model.items
                |> List.filterMap tryBuy
                |> List.head
    in
    case found of
        Just ( newItem, cost ) ->
            let
                itemsWithNewItem =
                    List.map (\i -> if i.id == id then newItem else i) model.items
                
                owned = getOwnedQty itemsWithNewItem
                newItems = 
                    List.map (\i -> {i | curPps = getItemPps i owned}) itemsWithNewItem
                    
                modelAfterBuy =
                    { model
                        | poop = model.poop - cost
                        , items = newItems
                        , poopPerSecond = calculatePps newItems
                    }
            in
            modelAfterBuy

        Nothing ->
            model

-- Helper to get quantities as a Dict for easy lookup
getOwnedQty : List Item -> Dict String Int
getOwnedQty items =
    items
        |> List.map (\i -> ( (itemMeta i.id).name , i.qty ))
        |> Dict.fromList

getNeighborBoost : String -> Dict String Int -> Float
getNeighborBoost name owned =
    let
        neighbors =
            Dict.fromList [ ( "Mine", "Factory" ), ( "Farm", "Mine" ), ( "Grandma", "Farm" ) ]
        neighborName = Dict.get name neighbors
    in
    case neighborName of
        Just nName ->
            let
                qty = Maybe.withDefault 0 (Dict.get nName owned)
            in
            1.03 ^ toFloat qty

        Nothing ->
            1.0

getCursorFactoryBonus : String -> Dict String Int -> Float
getCursorFactoryBonus name owned = 
    let
        factoryQty = Maybe.withDefault 0 (Dict.get "Factory" owned)
    in
    
        if name == "Cursor" && factoryQty > 0 then
            let
                ownedOther = 
                    owned 
                        |> Dict.filter (\n _ -> n /= "Cursor")
                        |> Dict.values
                        |> List.sum
                        |> toFloat
            in
            if ownedOther >= 200 then 0.5 * ownedOther
            else if ownedOther >= 100 then 0.1 * ownedOther
            else if ownedOther >= 50 then 0.05 * ownedOther
            else if ownedOther >= 25 then 0.01 * ownedOther
            else 0.0
        else
            0.0

getItemPps : Item -> Dict String Int -> Float
getItemPps item owned =
    let
        qty = max (toFloat item.qty - 1) 0
        name = (itemMeta item.id).name
        
        -- 1. Self-scaling multiplier
        selfMultiplier =
            if name == "Grandma" then
                if item.qty >= 50 then 1.05 ^ qty
                else if item.qty >= 25 then 1.04 ^ qty
                else if item.qty >= 10 then 1.03 ^ qty
                else 1.02 ^ qty
            else
                1.02 ^ qty

        -- 2. Global Synergy (Grandmas boost everything)
        grandmaQty = toFloat (Maybe.withDefault 0 (Dict.get "Grandma" owned))
        synergyBoost = (1.005 ^ grandmaQty) * getNeighborBoost name owned

        -- 3. Flat Modifiers (Cursor/Factory logic)
        flatModifiers = getCursorFactoryBonus name owned
    in
    (item.basePps + flatModifiers) * selfMultiplier * synergyBoost