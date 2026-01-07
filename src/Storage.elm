port module Storage exposing (save, clear, loadRequest, loadResponse)

-- Send JSON string to JS to save
port save : String -> Cmd msg

-- Tell JS to clear the key
port clear : () -> Cmd msg

-- Request a load (sent from init)
port loadRequest : () -> Cmd msg

-- Receive the JSON string from JS
port loadResponse : (Maybe String -> msg) -> Sub msg