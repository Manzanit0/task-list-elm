module Helpers exposing (toDateString)

import Time exposing (Month(..), toDay, toMonth, toYear, utc)


toDateString : Time.Posix -> String
toDateString time =
    dayToString (toDay utc time)
        ++ "/"
        ++ toNumericalMonth (toMonth utc time)
        ++ "/"
        ++ String.fromInt (toYear utc time)


dayToString : Int -> String
dayToString int =
    if int < 10 then
        "0" ++ String.fromInt int

    else
        String.fromInt int


toNumericalMonth : Month -> String
toNumericalMonth month =
    case month of
        Jan ->
            "01"

        Feb ->
            "02"

        Mar ->
            "03"

        Apr ->
            "04"

        May ->
            "05"

        Jun ->
            "06"

        Jul ->
            "07"

        Aug ->
            "08"

        Sep ->
            "09"

        Oct ->
            "10"

        Nov ->
            "11"

        Dec ->
            "12"
