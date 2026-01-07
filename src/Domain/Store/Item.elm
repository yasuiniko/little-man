module Domain.Store.Item exposing (..)
import Assets exposing (placeholderImage)
import Codec exposing (Codec)

type ItemId = Cursor | Grandma | Farm | Mine | Factory
itemIdCodec : Codec ItemId
itemIdCodec =
    Codec.custom
        (\cursor grandma farm mine factory value ->
            case value of
                Cursor -> cursor
                Grandma -> grandma
                Farm -> farm
                Mine -> mine
                Factory -> factory
        )
        |> Codec.variant0 "Cursor" Cursor
        |> Codec.variant0 "Grandma" Grandma
        |> Codec.variant0 "Farm" Farm
        |> Codec.variant0 "Mine" Mine
        |> Codec.variant0 "Factory" Factory
        |> Codec.buildCustom

type alias Item =
    { id : ItemId
    , description : String
    , baseCost : Float
    , basePps : Float
    , curPps : Float
    , qty : Int
    }
itemCodec : Codec Item
itemCodec =
    Codec.object Item
        |> Codec.field "itemId" .id itemIdCodec
        |> Codec.field "description" .description Codec.string
        |> Codec.field "baseCost" .baseCost Codec.float
        |> Codec.field "basePps" .basePps Codec.float
        |> Codec.field "curPps" .curPps Codec.float
        |> Codec.field "qty" .qty Codec.int
        |> Codec.buildObject

type alias ItemMeta = 
    { name : String
    , image : String
    }

itemMeta : ItemId -> ItemMeta
itemMeta id =
    let
        name = case id of
            Cursor -> "Cursor"
            Grandma -> "Grandma"
            Farm -> "Farm"
            Mine -> "Mine"
            Factory -> "Factory"
    in
    { name = name, image = placeholderImage name }

initialItems : List Item
initialItems =
    [ { id = Cursor, description = "Automatic tiny squeeze.", baseCost = 15, basePps = 0.1, curPps = 0.1, qty = 0 }
    , { id = Grandma, description = "A nice tummy squishing grandma.", baseCost = 200, basePps = 1.0, curPps = 1, qty = 0 }
    , { id = Farm, description = "Manure to millions.", baseCost = 1100, basePps = 8, curPps = 8, qty = 0 }
    , { id = Mine, description = "Mine deep chocolate.", baseCost = 12000, basePps = 47, curPps = 47, qty = 0 }
    , { id = Factory, description = "Mass production.", baseCost = 130000, basePps = 260, curPps = 260, qty = 0 }
    ]


