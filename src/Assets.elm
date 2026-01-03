port module Assets exposing (..)

port playSound : String -> Cmd msg

placeholderImage : String -> String
placeholderImage name =
    case name of
        _ -> "https://placehold.co/64x64/png?text=" ++ name

type alias PpsTier =
    { min : Float
    , label : String
    , color : String
    }

tiers : List PpsTier
tiers =
    [ { min = 0,     label = "little poop man",         color = "8B4513" } -- earthy
    , { min = 10,    label = "big poop man",            color = "CD853F" } -- sienna
    , { min = 50,    label = "super poop man",          color = "D4AF37" } -- gold
    , { min = 100,   label = "ultra poop man",          color = "FFD700" } -- eye searing gold
    
    , { min = 200,   label = "volcanic poop man",        color = "1B1B1B" } -- volcanic rock
    , { min = 500,   label = "tectonic poop man",       color = "7A7A7A" } -- deeper rock
    , { min = 1000,   label = "worldwide poop man",      color = "4A90E2" } -- earth blue
   
    , { min = 2000,  label = "lunar poop man",          color = "c0c0c0" } -- silver
    , { min = 5000,  label = "solar poop man",          color = "fce570" } -- yellow
    , { min = 10000,  label = "stellar poop man",        color = "e9eeee" } -- stellar white

    , { min = 20000,  label = "galactic poop man",       color = "5b3f00" } -- space
    , { min = 50000,  label = "intergalactic poop man",  color = "20124d" } -- deep space
   
    , { min = 100000, label = "total poop man",          color = "3461a4" } -- blueish
    , { min = 200000, label = "complete poop man",       color = "16ede6" } -- tealish
    , { min = 500000, label = "little poop man", color = "8B4513" } -- full circle
    ]


poopUrl : PpsTier -> String
poopUrl tier =
    let
        text =
            tier.label
                |> String.split " "
                |> String.join "\\n"
    in
    "https://placehold.co/200x200/" ++ tier.color ++ "/FFF?text=" ++ text

getPoopImage : Float -> String
getPoopImage pps =
    let
        best : Maybe PpsTier
        best =
            List.foldl
                (\t acc -> if pps >= t.min then Just t else acc)
                Nothing
                tiers
    in
    case best of
        Just t ->
            poopUrl t

        Nothing ->
            -- fallback (shouldn't happen if tiers non-empty)
            poopUrl (List.head tiers |> Maybe.withDefault { min = 0, label = "little poop man", color = "8B4513" })
