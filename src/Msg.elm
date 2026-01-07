module Msg exposing (..)

import Domain.Achievement.Model exposing (Achievement)
import Domain.Store.Item exposing (Item, ItemId)
import Time


type Msg
    = Clickpoop
    | BuyItem ItemId
    | Tick Time.Posix
    | KeyPressed String
    | Hover Achievement
    | Unhover
    | LoadedGame (Maybe String)
    | AutoSave
    | RequestReset
    | CancelReset
    | ConfirmReset