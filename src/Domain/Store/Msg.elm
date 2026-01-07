module Domain.Store.Msg exposing (..)
import Domain.Store.Item exposing (ItemId)

type Msg
    = StoreClickPoop
    | BuyItem ItemId
    | StoreTick
    | KeyPressed String