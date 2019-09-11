module Models exposing (Task)

import Time

type alias Task =
    { description : String, date : Time.Posix }