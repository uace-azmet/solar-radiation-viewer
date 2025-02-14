apiStartDate <- lubridate::date("2021-01-01")

azmetStationMetadata <- vroom::vroom(
  file = "aux-files/azmet-stations-api-db.csv", 
  delim = ",", 
  col_names = TRUE, 
  show_col_types = FALSE
)
