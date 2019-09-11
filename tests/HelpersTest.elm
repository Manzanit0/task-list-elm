module HelpersTest exposing (..)

import Expect
import Fuzz exposing (int)
import Helpers
import Regex
import Test exposing (Test, describe, fuzz, test)
import Time


suite : Test
suite =
    describe "Generic helper functions"
        [ test "transforms a Time.Posix value into a formatted date string" <|
            \_ ->
                let
                    posix =
                        Time.millisToPosix 730544400000
                in
                Expect.equal "24/02/1993" (Helpers.toDateString posix)
        , fuzz int "epoch values give sensible strings" <|
            \randomlyGeneratedInteger ->
                let
                    -- This expression verifies that the date has the format "dd/MM/YYYY"
                    expression =
                        Regex.fromString "^([0-2][0-9]|(3)[0-1])(\\/)(((0)[0-9])|((1)[0-2]))(\\/)\\d{4}$"

                    regexContains =
                        Regex.contains (Maybe.withDefault Regex.never expression)
                in
                randomlyGeneratedInteger
                    |> Time.millisToPosix
                    |> Helpers.toDateString
                    |> regexContains
                    |> Expect.equal True
        ]
