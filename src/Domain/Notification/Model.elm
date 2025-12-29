module Domain.Notification.Model exposing (..)

type alias Notification =
    { message : String
    , life : Float -- Remaining visibility time in seconds
    }