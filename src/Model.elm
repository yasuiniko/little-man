module Model exposing (..)

import Msg exposing (Msg(..))
import Domain.Achievement.Model as Achievement
import Domain.Notification.Model exposing (Notification)
import Domain.Store.Model as Store


type alias Model =
    { storeModel : Store.Model
    , achievementModel : Achievement.Model
    , notification : Maybe Notification
    }

config : { hz : Float, bgGradient : String, cardBg : String, accent : String }
config =
    { hz = 10
    , bgGradient = "linear-gradient(180deg, #031025 0%, #071028 100%)"
    , cardBg = "#0b1220"
    , accent = "#f59e0b"
    }

init : () -> Model
init _ =
    { storeModel = Store.init ()
    , achievementModel = Achievement.init ()
    , notification = Nothing
    }

