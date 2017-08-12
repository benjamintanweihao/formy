module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, list, string)


main : Program Never Model Msg
main =
    Html.program
        { init = initModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { imageDetails : List ImageDetail, selectedImage : String }


initModel : ( Model, Cmd Msg )
initModel =
    ( { imageDetails = [], selectedImage = "No image selected" }
    , getImageDetails
    )



-- UPDATE


type Msg
    = FetchImageDetails
    | NewImageDetails (Result Http.Error (List ImageDetail))
    | SetSelectedImage String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewImageDetails (Ok imageDetails) ->
            ( Model imageDetails "", Cmd.none )

        NewImageDetails (Err x) ->
            ( model, Cmd.none )

        FetchImageDetails ->
            ( model, Cmd.none )

        SetSelectedImage repoName ->
            let
                selectedImageDetail =
                    List.head (List.filter (\id -> id.repositoryName == repoName) model.imageDetails)

                selectedImageTag =
                    case selectedImageDetail of
                        Just imageDetail ->
                            toString imageDetail.imageTags

                        _ ->
                            ""
            in
            ( Model model.imageDetails selectedImageTag, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        imageDetails =
            model.imageDetails

        selectedImage =
            model.selectedImage
    in
    div []
        [ select [ onInput SetSelectedImage ] (displayOptions imageDetails)
        , input [ type_ "text", placeholder selectedImage, disabled True ] []
        ]


displayOptions : List ImageDetail -> List (Html Msg)
displayOptions imageDetails =
    case imageDetails of
        [] ->
            [ option [ value "", disabled True ] [ text "Fetching list of images ..." ] ]

        _ ->
            let
                firstOption =
                    option [ value "", disabled True, selected True ] [ text "Select image" ]

                options =
                    List.map displayOption imageDetails
            in
            firstOption :: options


displayOption : ImageDetail -> Html Msg
displayOption imageDetail =
    let
        repositoryName =
            imageDetail.repositoryName
    in
    option [ value repositoryName ] [ text repositoryName ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- HTTP


type alias ImageTag =
    String


type alias ImageDetail =
    { repositoryName : String
    , imageTags : List ImageTag
    }


getImageDetails : Cmd Msg
getImageDetails =
    Http.send NewImageDetails (Http.get url imageDetailListDecoder)


url : String
url =
    "http://localhost:3000/imageDetails"


imageDetailListDecoder : Decoder (List ImageDetail)
imageDetailListDecoder =
    Decode.list imageDetailDecoder


imageDetailDecoder : Decode.Decoder ImageDetail
imageDetailDecoder =
    Decode.map2
        ImageDetail
        (Decode.at [ "repositoryName" ] Decode.string)
        (Decode.at [ "imageTags" ] (Decode.list Decode.string))
