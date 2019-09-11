module Main exposing (Model, Msg(..), addTaskButton, init, main, update, view)

import Browser
import Components exposing (button, input, tasksTable)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Html exposing (Html)
import Models exposing (Task)
import Task
import Time exposing (toHour, toMinute, toSecond, utc)


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    { tasks : List Task, taskName : String }


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
            ( { model | tasks = appendTask model.tasks description datetime }, Cmd.none )



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


asyncTaskCreation : String -> Cmd Msg
asyncTaskCreation description =
    Task.perform (OnTime description) Time.now


newTask : String -> Time.Posix -> Task
newTask description date =
    { description = description, date = date }


appendTask : List Task -> String -> Time.Posix -> List Task
appendTask tasks taskDescription datetime =
    List.append [ newTask taskDescription datetime ] tasks
