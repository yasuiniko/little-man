module Domain.Achievement.Msg exposing (..)

import Domain.Achievement.Model exposing (Achievement)

type Msg 
    = Hover Achievement
    | Unhover