module Msg exposing (..)

import Domain.Achievement.Model exposing (Achievement)
import Domain.Store.Model exposing (Item, ItemId)
import Time


type Msg
    = Clickpoop
    | BuyItem ItemId
    | Tick Time.Posix
    | KeyPressed String
    | Hover Achievement
    | Unhover
    | CheckAchievements (Float, List Item)
    | AddNotification String
