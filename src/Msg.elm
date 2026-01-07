module Msg exposing (..)

import Domain.Achievement.Msg as Achievement
import Domain.Store.Msg as Store
import Time


type Msg
    = Clickpoop
    | Tick Time.Posix
    | KeyPressed String
    | StoreMsg Store.Msg
    | AchievementMsg Achievement.Msg
    | LoadedGame (Maybe String)
    | AutoSave
    | RequestReset
    | CancelReset
    | ConfirmReset