module Domain.Notification.Utils exposing (..)

import Domain.Notification.Model exposing (Notification)

tickNotification : Float -> Notification -> Maybe Notification
tickNotification deltaTime notification =
    let
        newLife = notification.life - deltaTime
    in
    if newLife > 0 then
        Just { notification | life = newLife }
    else
        Nothing

tickMaybeNotification : Float -> Maybe Notification -> Maybe Notification
tickMaybeNotification deltaTime maybeNotification =
    maybeNotification
        |> Maybe.andThen (tickNotification deltaTime)