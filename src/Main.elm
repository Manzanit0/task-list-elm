module Main exposing (Model, Msg(..), addTaskButton, init, main, update, view)

import Browser
import Components exposing (button, input, tasksTable)
import Element exposing (..)
import Html exposing (Html)
import Http
import Json.Decode exposing (Decoder, field, string)
import Models exposing (Todo)
import Task
import Time


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    { tasks : List Todo, taskName : String }


init : () -> ( Model, Cmd msg )
init _ =
    ( { tasks = [], taskName = "" }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = AddTask String
    | RemoveTask String
    | Change String
    | OnTime String Time.Posix
    | GotPerson String (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newContent ->
            ( { model | taskName = newContent }, Cmd.none )

        AddTask description ->
            ( model, asyncTaskCreation description )

        RemoveTask description ->
            ( { model | tasks = List.filter (\current -> current.description /= description) model.tasks }, Cmd.none )

        OnTime description datetime ->
            ( { model | tasks = appendTask model.tasks description datetime }, asyncPersonGenerator description )

        GotPerson description result ->
            case result of
                Ok body ->
                    ( { model | tasks = appendAssigneeToTask model.tasks description body }, Cmd.none )

                Err _ ->
                    ( model, asyncPersonGenerator description )



-- VIEW


view : Model -> Html Msg
view model =
    layout [ spacing 20, padding 20 ]
        (column [ centerX, centerY ]
            [ taskNameInput model.taskName
            , buttonPad model.taskName
            , tasksTable model.tasks
            ]
        )


buttonPad : String -> Element Msg
buttonPad taskName =
    row [ spacing 20, padding 20 ] [ addTaskButton taskName, removeTaskButton taskName ]


removeTaskButton : String -> Element Msg
removeTaskButton taskName =
    button (Just (RemoveTask taskName)) "Remove tasks"


addTaskButton : String -> Element Msg
addTaskButton taskName =
    button (Just (AddTask taskName)) "Add task"


taskNameInput : String -> Element Msg
taskNameInput taskName =
    input Change "Task name" "Task name" taskName



-- Business logic


asyncPersonGenerator : String -> Cmd Msg
asyncPersonGenerator description =
    Http.get
        { url = "https://uinames.com/api/"
        , expect = Http.expectJson (GotPerson description) personDecoder
        }


asyncTaskCreation : String -> Cmd Msg
asyncTaskCreation description =
    Task.perform (OnTime description) Time.now


newTask : String -> Time.Posix -> String -> Todo
newTask description date assignee =
    { description = description, date = date, assignee = assignee }


appendTask : List Todo -> String -> Time.Posix -> List Todo
appendTask tasks taskDescription datetime =
    List.append [ newTask taskDescription datetime "" ] tasks


appendAssigneeToTask : List Todo -> String -> String -> List Todo
appendAssigneeToTask tasks taskDescription assignee =
    List.map
        (\task ->
            if task.description == taskDescription then
                newTask task.description task.date assignee

            else
                task
        )
        tasks


personDecoder =
    field "name" string
