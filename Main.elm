module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update}

-- MODEL

type alias Model = {}

model : Model
model = {}

-- UPDATE

type Msg = Foo

update : Msg -> Model -> Model
update msg model =
    model


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Image URL", disabled True] []
        , input [ type_ "text", placeholder "Image Version", disabled True] []
        ]

    -- [ input [ type_ "text", placeholder "Name", onInput Name ] []

