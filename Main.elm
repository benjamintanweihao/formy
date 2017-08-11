module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (..)
import Http exposing (..)


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

type alias ImageTag = String


type alias ImageDetail =
    { repositoryName : String
    , imageTags : List ImageTag
    }


imageDetailListDecoder : Decoder (List ImageDetail)
imageDetailListDecoder =
    Decode.list imageDetailDecoder


imageDetailDecoder : Decode.Decoder ImageDetail
imageDetailDecoder =
    Decode.map2
      ImageDetail
      (Decode.at [ "repositoryName" ] Decode.string)
      (Decode.at [ "imageTags" ] (Decode.list Decode.string))


url : String
url =
    "https://my-json-server.typicode.com/benjamintanweihao/formy/imageDetails"


getImageDetails : Http.Request (List ImageDetail)
getImageDetails =
    Http.get url imageDetailListDecoder
