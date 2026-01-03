module Domain.Store.Model exposing (..)
import Assets exposing (placeholderImage)

type alias Model =
    { poop : Float
    , totalpoop : Float
    , clickPower : Float
    , items : List Item
    , poopPerSecond : Float
    }

type ItemId = Cursor | Grandma | Farm | Factory | Mine

type alias Item =
    { id : ItemId
    , description : String
    , baseCost : Float
    , basePps : Float
    , curPps : Float
    , qty : Int
    }

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
            Factory -> "Factory"
            Mine -> "Mine"
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

init : () -> Model
init _ =
    { poop = 0
    , totalpoop = 0
    , clickPower = 1
    , items = initialItems
    , poopPerSecond = 0
    }
