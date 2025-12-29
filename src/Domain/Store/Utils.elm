module Domain.Store.Utils exposing (..)

import Domain.Store.Model exposing (Item, Model)
import Msg exposing (Msg(..))
import Domain.Store.Model exposing (ItemId)

calculatepps : List Item -> Float
calculatepps items =
    items
        |> List.map (\i -> i.poopPerSecond * toFloat i.qty)
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
                    cost =
                        calculateCost item
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
                newItems =
                    List.map (\i -> if i.id == id then newItem else i) model.items
                    
                modelAfterBuy =
                    { model
                        | poop = model.poop - cost
                        , items = newItems
                        , poopPerSecond = model.poopPerSecond + newItem.poopPerSecond
                    }
            in
            modelAfterBuy

        Nothing ->
            model