module Domain.Notification.Model exposing (..)

import Codec exposing (Codec)

type alias Model =
    { message : String
    , life : Float -- Remaining visibility time in seconds
    }
modelCodec : Codec Model
modelCodec =
    Codec.object Model
        |> Codec.field "message" .message Codec.string
        |> Codec.field "life" .life Codec.float
        |> Codec.buildObject