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
import Domain.Achievement.Utils exposing (checkAllDone)

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
            if key == "k" || key == "x" then
                let
                    updatedStoreModel = updateStore (KeyPressed key) model.storeModel 
                    updatedModel = { model | storeModel = updatedStoreModel }  
                in
                ( updatedModel, Cmd.none )
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
                
                allDone = checkAllDone model.achievementModel.achievements model.storeModel.poopPerSecond
                gameDoneMsg = "Congratulations! You finished the game :). Thanks for playing!"

                finalMsg =
                    if updatedNotification == Nothing && allDone then
                        AddNotification ( gameDoneMsg, 3600*24*365 )
                    else
                        achMsg
            in
            update finalMsg updatedModel
                    

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
                    update (AddNotification (message, 4.0)) updatedModel
                Nothing ->
                    ( updatedModel, Cmd.none )
        AddNotification ( message, duration ) ->
            let
                note = Notification message duration
            in
            ( { model | notification = Just note }, playSound "achievement" )