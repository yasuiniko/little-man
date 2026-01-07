module Msg exposing (..)

import Domain.Achievement.Msg as Achievement
import Domain.Store.Item exposing (Item, ItemId)
import Time


type Msg
    = Clickpoop
    | BuyItem ItemId
    | Tick Time.Posix
    | KeyPressed String
    | AchievementMsg Achievement.Msg
    | LoadedGame (Maybe String)
    | AutoSave
    | RequestReset
    | CancelReset
    | ConfirmReset