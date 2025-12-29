module Domain.Achievement.Utils exposing (computeNewUnlocks, applyUnlocks, groupAchievements)

import Domain.Store.Model exposing (Item, ItemId)
import Domain.Achievement.Model exposing (Achievement, AchievementKind(..), Model)
import Dict exposing (Dict)
import Domain.Store.Model exposing (ItemId(..))

hasQty : ItemId -> Int -> List Item -> Bool
hasQty id amount items =
    items
        |> List.filter (\i -> i.id == id)
        |> List.head
        |> Maybe.map (\i -> i.qty >= amount)
        |> Maybe.withDefault False

isUnlocked : Float -> List Item -> Achievement -> Bool
isUnlocked modelTotalpoop modelItems ach =
    not ach.unlocked &&
    case ach.kind of
        Totalpoop n -> modelTotalpoop >= n
        OwnItem itemId qty -> hasQty itemId qty modelItems


computeNewUnlocks : Float -> List Item -> List Achievement -> List Achievement
computeNewUnlocks totalpoop items achievements =
    let
        achIsUnlocked = isUnlocked totalpoop items
    in
    List.filter achIsUnlocked achievements

applyUnlocks : List Achievement -> Model -> Model
applyUnlocks unlocked model =
    let
        newAchievements =
            List.map
                (\ach -> if List.member ach unlocked then { ach | unlocked = True } else ach)
                model.achievements
    in
    { model | achievements = newAchievements }

kindToString : AchievementKind -> String
kindToString kind =
    case kind of 
        Totalpoop _ -> 
            "01PoopCount"
        OwnItem Cursor _->
            "02Cursor"
        OwnItem Grandma _->
            "03Grandma"
        OwnItem Farm _->
            "04Farm"
        OwnItem Factory _->
            "05Factory"
        OwnItem Mine _->
            "06Mine"

groupAchievements : List Achievement -> List ( String, List Achievement )
groupAchievements achievements =
    -- This results in a list of tuples: [ ("A", [A1, A2]), ("B", [B1..]) ]
    let
        insert achievement grid =
            let
                category = kindToString achievement.kind
            in
            Dict.update category
                (\existing ->
                    case existing of
                        Just list -> Just (list ++ [ achievement ])
                        Nothing -> Just [ achievement ]
                )
                grid
    in
    achievements
        |> List.foldl insert Dict.empty
        |> Dict.toList