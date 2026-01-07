module Domain.Store.Model exposing (..)

import Domain.Store.Item exposing(Item, initialItems, itemCodec)
import Codec exposing (Codec)
import Domain.Achievement.Model exposing (AchievementKind(..))
import Msg exposing (Msg(..))

type alias Model =
    { poop : Float
    , totalpoop : Float
    , clickPower : Float
    , items : List Item
    , poopPerSecond : Float
    }
modelCodec : Codec Model
modelCodec =
    Codec.object Model
        |> Codec.field "poop" .poop Codec.float
        |> Codec.field "totalpoop" .totalpoop Codec.float
        |> Codec.field "clickPower" .clickPower Codec.float
        |> Codec.field "items" .items (Codec.list itemCodec)
        |> Codec.field "poopPerSecond" .poopPerSecond Codec.float
        |> Codec.buildObject

init : () -> Model
init _ =
    { poop = 0
    , totalpoop = 0
    , clickPower = 1
    , items = initialItems
    , poopPerSecond = 0
    }