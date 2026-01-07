module Model exposing (..)

import Msg exposing (Msg(..))
import Domain.Achievement.Model as Achievement
import Domain.Store.Model as Store
import Domain.Notification.Model as Notification

import Codec exposing (Codec)

type ModalState
    = NoModal
    | ConfirmingReset
modalStateCodec: Codec ModalState
modalStateCodec = 
    Codec.custom
        (\noModal confirmingReset value ->
            case value of
                NoModal -> noModal
                ConfirmingReset -> confirmingReset
        )
        |> Codec.variant0 "NoModal" NoModal
        |> Codec.variant0 "ConfirmingReset" ConfirmingReset
        |> Codec.buildCustom

type alias Model =
    { storeModel : Store.Model
    , achievementModel : Achievement.Model
    , notification : Maybe Notification.Model
    , modalState : ModalState
    }
modelCodec : Codec Model
modelCodec =
    Codec.object Model
        |> Codec.field "storeModel" .storeModel Store.modelCodec
        |> Codec.field "achievementModel" .achievementModel Achievement.modelCodec
        |> Codec.optionalMaybeField "notification" .notification (Codec.maybe Notification.modelCodec)
        |> Codec.field "modalState" .modalState modalStateCodec
        |> Codec.buildObject

config : { hz : Float, bgGradient : String, cardBg : String, accent : String }
config =
    { hz = 10
    , bgGradient = "linear-gradient(180deg, #031025 0%, #071028 100%)"
    , cardBg = "#0b1220"
    , accent = "#f59e0b"
    }

modelInit : () -> Model
modelInit _ =
    { storeModel = Store.init ()
    , achievementModel = Achievement.init ()
    , notification = Nothing
    , modalState = NoModal
    }