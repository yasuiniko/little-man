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
    , poopPerSecond : Float
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
    [ { id = Cursor, description = "Automatic tiny squeeze.", baseCost = 15, poopPerSecond = 0.15, qty = 0 }
    , { id = Grandma, description = "A nice tummy squishing grandma.", baseCost = 100, poopPerSecond = 2, qty = 0 }
    , { id = Farm, description = "Manure to millions.", baseCost = 1100, poopPerSecond = 8, qty = 0 }
    , { id = Mine, description = "Mine deep chocolate.", baseCost = 12000, poopPerSecond = 47, qty = 0 }
    , { id = Factory, description = "Mass production.", baseCost = 130000, poopPerSecond = 260, qty = 0 }
    ]

init : () -> Model
init _ =
    { poop = 0
    , totalpoop = 0
    , clickPower = 1
    , items = initialItems
    , poopPerSecond = 0
    }
