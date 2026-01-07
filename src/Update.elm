module Update exposing (..)

import Msg exposing (Msg(..))
import Model exposing (Model, config, ModalState(..), modelCodec, modelInit)
import Assets exposing (playSound)
import Storage 
import Domain.Achievement.Msg as Achievement
import Domain.Achievement.Update exposing (updateAchievements)
import Domain.Achievement.Utils exposing (computeNewUnlocks, applyUnlocks, checkAllDone)
import Domain.Notification.Model as Notification
import Domain.Notification.Utils exposing (tickMaybeNotification)
import Domain.Store.Msg as Store
import Domain.Store.Update exposing (updateStore)

import Codec exposing (Codec, Error)


type Context = Sound String | NoContext

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Clickpoop ->
            model
                |> updateStoreModel Store.StoreClickPoop
                |> handleAchievements (Sound "click")

        KeyPressed key ->
            if key == "k" || key == "x" then
                model
                    |> updateStoreModel (Store.KeyPressed key)
                    |> withNoCmd
            else
                ( model, Cmd.none )

        Tick _ ->
            model
                |> updateStoreModel (Store.StoreTick)
                |> updateNotification (1.0 / config.hz) 
                |> handleAchievements NoContext
                |> step handleGameCompletion
        
        AutoSave ->
            model |> withSaveCmd

        StoreMsg m ->
            model 
                |> updateStoreModel m
                |> handleAchievements (Sound "store")
            
        AchievementMsg achievementMsg -> 
            model 
                |> updateAchievementModel achievementMsg
                |> withNoCmd
        LoadedGame maybeModelString ->
            decodeModel maybeModelString
                |> withNoCmd
        RequestReset -> 
            { model | modalState = ConfirmingReset }
                |> withNoCmd
        CancelReset -> 
            { model | modalState = NoModal }
                |> withNoCmd
        ConfirmReset -> 
            modelInit ()
                |> withCmd ( Storage.clear () )

maybeLast : List a -> Maybe a         
maybeLast =            
    List.reverse >> List.head

decodeModel : Maybe String -> Model
decodeModel maybeString =
    maybeString
        |> Maybe.andThen (Codec.decodeString modelCodec >> Result.toMaybe)
        |> Maybe.withDefault (modelInit ())

updateAchievementModel : Achievement.Msg -> Model -> Model
updateAchievementModel msg model = 
    { model | achievementModel = updateAchievements msg model.achievementModel} 

updateStoreModel : Store.Msg -> Model -> Model
updateStoreModel msg model = 
    { model | storeModel = updateStore msg model.storeModel} 

step : (Model -> ( Model, Cmd msg )) -> ( Model, Cmd msg ) -> ( Model, Cmd msg )
step fn ( model, accumulatedCmds ) =
    let
        ( nextModel, nextCmd ) = fn model
    in
    ( nextModel, Cmd.batch [ accumulatedCmds, nextCmd ] )

handleAchievements : Context -> Model -> ( Model, Cmd msg )
handleAchievements context model =
    let
        unlocks =
            computeNewUnlocks 
                model.storeModel.totalpoop 
                model.storeModel.items 
                model.achievementModel.achievements

        updatedModel =
            { model | achievementModel = applyUnlocks unlocks model.achievementModel }
    in
    case maybeLast unlocks of
        Just achievement -> 
            let
                message = "Achievement: '" ++ achievement.name ++ "'"
                sound = 
                    case context of 
                        Sound "click" -> 
                            "clickAch"
                        Sound "store" -> 
                            "storeAch"
                        _ -> "achievement"
            in
            addNotification message config.notifDuration sound updatedModel

        Nothing ->
            case context of 
                Sound sound -> 
                    updatedModel |> withSoundEffect sound 
                _ -> 
                    updatedModel |> withNoCmd

addNotification : String -> Float -> String -> Model -> ( Model, Cmd msg )
addNotification message duration sound model =
    { model | notification = Just (Notification.Model message duration) }
        |> withSoundEffect sound

updateNotification : Float -> Model -> Model
updateNotification dt model = 
    { model | notification = tickMaybeNotification dt model.notification }

handleGameCompletion : Model -> ( Model, Cmd msg )
handleGameCompletion model = 
        if (checkAllDone 
                model.achievementModel.achievements
                model.storeModel.poopPerSecond
            && model.notification == Nothing) then
            model
                |> addNotification 
                    "Congratulations! You finished the game :). Thanks for playing!" 
                    ( 60 * 925600 )-- one year
                    "achievement"
        else
            model |> withNoCmd

withSoundEffect : String -> Model -> (Model, Cmd msg)
withSoundEffect sound model =
    ( model, playSound sound)
withNoCmd : Model -> ( Model, Cmd msg )
withNoCmd model = ( model, Cmd.none )
withCmd : Cmd msg -> Model -> ( Model, Cmd msg )
withCmd cmd model = ( model, cmd )
withSaveCmd: Model -> (Model, Cmd msg)
withSaveCmd model = ( model, Storage.save (Codec.encodeToString 0 modelCodec model) )
