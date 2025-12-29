port module Assets exposing (..)

port playSound : String -> Cmd msg

placeholderImage : String -> String
placeholderImage name =
    case name of
        _ -> "https://placehold.co/64x64/png?text=" ++ name

getpoopImage : Float -> String
getpoopImage pps =
    if pps > 100 then
         -- Volcanic poop
        "https://placehold.co/200x200/520/FFF?text=tectonic\\npoop\\nman"

    else if pps > 50 then
         -- Factory poop
        "https://placehold.co/200x200/444/FFF?text=industrial\\npoop\\nman"

    else if pps > 10 then
         -- Golden poop
        "https://placehold.co/200x200/D4AF37/FFF?text=big\\npoop\\nman"

    else
         -- Standard poop
        "https://placehold.co/200x200/8B4513/FFF?text=little\\npoop\\nman"