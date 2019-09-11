module Components exposing (button, input, tasksTable)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Helpers exposing (toDateString)
import Models exposing (Task)


blue =
    Element.rgb255 135 206 250


tasksTable : List Task -> Element msg
tasksTable data =
    Element.table []
        { data = data
        , columns =
            [ { header = Element.text "Task"
              , width = fill
              , view =
                    \task ->
                        Element.text task.description
              }
            , { header = Element.text "Date created"
              , width = fill
              , view =
                    \task ->
                        Element.text (toDateString task.date)
              }
            ]
        }


input : (String -> msg) -> String -> String -> String -> Element msg
input onChangeAction labelText placeholderText textValue =
    Input.text [ centerX ]
        { onChange = onChangeAction
        , label = Input.labelAbove [] (text labelText)
        , placeholder = Just (Input.placeholder [] (text placeholderText))
        , text = textValue
        }


button : Maybe msg -> String -> Element msg
button onPressAction labelText =
    Input.button
        [ Background.color blue
        , Border.color (rgb 0 0 0)
        , Border.solid
        , Border.width 2
        , padding 10
        ]
        { onPress = onPressAction, label = text labelText }
