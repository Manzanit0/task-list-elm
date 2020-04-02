module Models exposing (Todo)

import Time


type alias Todo =
    { description : String, date : Time.Posix, assignee : String }
