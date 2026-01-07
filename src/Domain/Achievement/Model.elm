module Domain.Achievement.Model exposing (..)

import Domain.Store.Item exposing (ItemId(..))
import Codec exposing (Codec)
import Domain.Store.Item exposing (itemIdCodec)

type AchievementKind
    = TotalPoop Float
    | OwnItem ItemId Int

achievementKindCodec: Codec AchievementKind
achievementKindCodec =
   Codec.custom
        (\totalpoop ownitem value ->
            case value of
                TotalPoop f -> totalpoop f
                OwnItem id i -> ownitem id i
        )
        |> Codec.variant1 "Totalpoop" TotalPoop Codec.float
        |> Codec.variant2 "Ownitem" OwnItem itemIdCodec Codec.int
        |> Codec.buildCustom

type alias Achievement =
    { name : String
    , description : String
    , unlocked : Bool
    , kind : AchievementKind
    }
achievementCodec : Codec Achievement
achievementCodec =
    Codec.object Achievement
        |> Codec.field "name" .name Codec.string
        |> Codec.field "description" .description Codec.string
        |> Codec.field "unlocked" .unlocked Codec.bool
        |> Codec.field "kind" .kind achievementKindCodec
        |> Codec.buildObject


type alias Model = 
    { achievements : List Achievement
    , hoveredAchievement : Maybe Achievement
    }

modelCodec : Codec Model
modelCodec =
    Codec.object Model
        |> Codec.field "achievements" .achievements (Codec.list achievementCodec)
        |> Codec.optionalMaybeField "hoveredAchievement" .hoveredAchievement (Codec.maybe achievementCodec)
        |> Codec.buildObject

init : () -> Model
init _ = 
    { achievements = initialAchievements
    , hoveredAchievement = Nothing
    }

initialAchievements : List Achievement
initialAchievements =
    [ { name = "Up and at 'em"
      , description = "Squeeze him once"
      , unlocked = False
      , kind = TotalPoop 1
      }
    , { name = "Novice Squisher"
      , description = "Harvest 100 lifetime poop."
      , unlocked = False
      , kind = TotalPoop 100
      }
    , { name = "Pro Squisher"
      , description = "Harvest 1,000 lifetime poop."
      , unlocked = False
      , kind = TotalPoop 1000
      }
    , { name = "Elite Squisher"
      , description = "Harvest 1 million lifetime poop."
      , unlocked = False
      , kind = TotalPoop 1000000
      }
    , { name = "Ultra Squisher"
      , description = "Harvest 1 billion lifetime poop."
      , unlocked = False
      , kind = TotalPoop 1000000000
      }
    , { name = "French Squisher"
      , description = "Harvest 1 GDP of France."
      , unlocked = False
      , kind = TotalPoop 3162000000
      }

    
    , { name = "she is poking"
      , description = "Own 1 Cursor."
      , unlocked = False
      , kind = OwnItem Cursor 1
      }
    , { name = "Pointer Trails"
      , description = "Just one long streak."
      , unlocked = False
      , kind = OwnItem Cursor 5
      }
    , { name = "Baker's Dozen"
      , description = "13 reasons why."
      , unlocked = False
      , kind = OwnItem Cursor 25
      }
    , { name = "Vlad the Poker"
      , description = "\"We can always add another hole.\""
      , unlocked = False
      , kind = OwnItem Cursor 50
      }
    , { name = "Poking is as poking does"
      , description = "Whatever that means."
      , unlocked = False
      , kind = OwnItem Cursor 75
      }
    , { name = "Universal Coordinator"
      , description = "Eat, Poop, Die."
      , unlocked = False
      , kind = OwnItem Cursor 100
      }

    , { name = "Rolling pin online"
      , description = "Own 1 Grandma."
      , unlocked = False
      , kind = OwnItem Grandma 1
      }
    , { name = "Grandma's House"
      , description = "You're in Grandma's house now."
      , unlocked = False
      , kind = OwnItem Grandma 5
      }
    , { name = "Grandma's Maisonette"
      , description = "Full Duplex."
      , unlocked = False
      , kind = OwnItem Grandma 10
      }
    , { name = "Tower of Grandmas"
      , description = "3 dimensional squish."
      , unlocked = False
      , kind = OwnItem Grandma 25
      }
    , { name = "Empire State Grandma"
      , description = "New York don't play."
      , unlocked = False
      , kind = OwnItem Grandma 50
      }
    , { name = "Dubai Grandma"
      , description = "Is that pistachio inside?"
      , unlocked = False
      , kind = OwnItem Grandma 85
      }

    , { name = "Farmin' Manure"
      , description = "Own 1 Farm."
      , unlocked = False
      , kind = OwnItem Farm 1
      }
    , { name = "Old MacDonald"
      , description = "5 finger farming."
      , unlocked = False
      , kind = OwnItem Farm 5
      }
    , { name = "Petaluma Creamery"
      , description = "Creamy."
      , unlocked = False
      , kind = OwnItem Farm 10
      }
    , { name = "Slide Ranch"
      , description = "Nice easy slide."
      , unlocked = False
      , kind = OwnItem Farm 25
      }
    , { name = "Pronzini"
      , description = "Choppin' logs."
      , unlocked = False
      , kind = OwnItem Farm 50
      }
    , { name = "Los Pollos Hermanos"
      , description = "This operation is going international."
      , unlocked = False
      , kind = OwnItem Farm 75
      }


    , { name = "I Think I'm Getting the Black Lung, Pop"
      , description = "It's not very well ventilated down there."
      , unlocked = False
      , kind = OwnItem Mine 1
      }
    , { name = "Open Pit Mining"
      , description = "Just scratchin' the surface."
      , unlocked = False
      , kind = OwnItem Mine 5
      }
    , { name = "Shaft Mining"
      , description = "Vertical access."
      , unlocked = False
      , kind = OwnItem Mine 10
      }
    , { name = "Hard Rock Mining"
      , description = "Manual excavation."
      , unlocked = False
      , kind = OwnItem Mine 25
      }
    , { name = "Hydraulic Fracking"
      , description = "Hydrocarbon exploitation."
      , unlocked = False
      , kind = OwnItem Mine 50
      }
    , { name = "Underwater Cave Exploration"
      , description = "54% fecal microflora."
      , unlocked = False
      , kind = OwnItem Mine 75
      }

    , { name = "Industrial Revolution"
      , description = "Mass production."
      , unlocked = False
      , kind = OwnItem Factory 1
      }
    , { name = "The Means of Production"
      , description = "Straight siezin' it. and by it, lets just say. the pordoction."
      , unlocked = False
      , kind = OwnItem Factory 5
      }
    , { name = "Burgeoning Empire"
      , description = "Just the tip."
      , unlocked = False
      , kind = OwnItem Factory 10
      }
    , { name = "The 1%"
      , description = "Swimming in it."
      , unlocked = False
      , kind = OwnItem Factory 25
      }
    , { name = "Plutocrat"
      , description = "Don't need to brown-nose anymore."
      , unlocked = False
      , kind = OwnItem Factory 50
      }
    , { name = "Brat Summer"
      , description = "65 im (bumpin that)."
      , unlocked = False
      , kind = OwnItem Factory 65
      }
    
    ]