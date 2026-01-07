module Domain.Notification.Utils exposing (..)

import Domain.Notification.Model as Notification

tickNotification : Float -> Notification.Model -> Maybe Notification.Model
tickNotification deltaTime notification =
    let
        newLife = notification.life - deltaTime
    in
    if newLife > 0 then
        Just { notification | life = newLife }
    else
        Nothing

tickMaybeNotification : Float -> Maybe Notification.Model -> Maybe Notification.Model
tickMaybeNotification deltaTime maybeNotification =
    maybeNotification
        |> Maybe.andThen (tickNotification deltaTime)