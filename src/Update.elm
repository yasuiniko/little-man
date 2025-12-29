module Update exposing (..)

import Msg exposing (Msg(..))
import Model exposing (Model, config)
import Assets exposing (playSound)
import Domain.Achievement.Update exposing (updateAchievements)
import Domain.Achievement.Utils exposing (computeNewUnlocks, applyUnlocks)
import Domain.Notification.Model exposing (Notification)
import Domain.Notification.Utils exposing (tickMaybeNotification)
import Domain.Store.Utils exposing (buyItem)
import Domain.Store.Update exposing (updateStore)
import Domain.Store.Model as Store

getAchMsg: Store.Model -> Msg
getAchMsg storeModel = CheckAchievements (storeModel.totalpoop, storeModel.items)

maybeLastElem : List a -> Maybe a         
maybeLastElem =            
    List.foldl (Just >> always) Nothing

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Clickpoop ->
            let
                updatedStoreModel = updateStore Clickpoop model.storeModel
                updatedModel = { model | storeModel = updatedStoreModel}

                achMsg = getAchMsg updatedStoreModel
                ( newModel, newMsg )  = update achMsg updatedModel
            in
            if newMsg == Cmd.none then
                ( newModel, playSound "click" )
            else
                ( newModel, playSound "clickAch")

        KeyPressed key ->
            if key == "k" then
                update Clickpoop model
            else
                ( model, Cmd.none )

        Tick i ->
            let
                updatedStoreModel = updateStore (Tick i) model.storeModel

                -- Update Notifications (decrease life, remove old ones)
                dt =
                    1.0 / config.hz
                    
                updatedNotification = tickMaybeNotification dt model.notification

                updatedModel =
                    { model | notification = updatedNotification, storeModel = updatedStoreModel}
                achMsg = getAchMsg updatedStoreModel
            in
            update achMsg updatedModel

        BuyItem id ->
            let
                updatedStoreModel = buyItem id model.storeModel
                updatedModel = { model | storeModel = updatedStoreModel }
                achMsg = getAchMsg updatedStoreModel
                ( newModel, newMsg ) = update achMsg updatedModel
            in
            if newMsg == Cmd.none then
                ( newModel, playSound "store" )
            else
                ( newModel, playSound "storeAch")
            
        Hover ach ->
            let
                updatedAchievementModel = updateAchievements (Hover ach) model.achievementModel

                updatedModel = { model | achievementModel = updatedAchievementModel}
            in 
            ( updatedModel, Cmd.none)

        Unhover ->
            let
                updatedAchievementModel = updateAchievements Unhover model.achievementModel

                updatedModel = { model | achievementModel = updatedAchievementModel}
            in 
            ( updatedModel, Cmd.none)
        CheckAchievements (totalpoop, items) ->
            let
                unlocks = computeNewUnlocks totalpoop items model.achievementModel.achievements              
                updatedAchievementModel = applyUnlocks unlocks model.achievementModel

                updatedModel = { model | achievementModel = updatedAchievementModel }

                maybeNewAchievement = maybeLastElem unlocks
            in 
            case maybeNewAchievement of
                Just ach ->
                    let
                        message = "Achievement: '" ++ ach.name ++ "'" 
                    in
                    update (AddNotification message) updatedModel
                Nothing ->
                    ( updatedModel, Cmd.none )
        AddNotification message ->
            let
                note = Notification message 4.0
            in
            ( { model | notification = Just note }, playSound "achievement" )