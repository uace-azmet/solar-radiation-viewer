sidebar <- bslib::sidebar(
  width = 300,
  position = "left",
  open = list(
    desktop = "open", 
    mobile = "always-above"
  ),
  id = "sidebar",
  title = NULL,
  bg = "#FFFFFF",
  fg = "#191919", # https://www.color-hex.com/color-palette/1041718
  class = NULL,
  max_height_mobile = NULL,
  gap = NULL,
  padding = NULL,
  
  htmltools::p(
    bsicons::bs_icon("sliders"), 
    htmltools::HTML("&nbsp;"), 
    "DATA OPTIONS"
  ),
  
  shiny::helpText(
    "Select an AZMet station, and set dates for the period of interest. Then, click or tap 'RETRIEVE DATA'."
  ),
  
  #htmltools::br(),
  shiny::selectInput(
    inputId = "azmetStation", 
    label = "AZMet Station",
    choices = 
      azmetStationMetadata[order(azmetStationMetadata$meta_station_name), ]$meta_station_name,
    selected = "Aguila"
  ),
  
  shiny::dateInput(
    inputId = "startDate",
    label = "Start Date",
    value = lubridate::today(tzone = "America/Phoenix") - lubridate::dyears(x = 4),
    min = apiStartDate,
    max = lubridate::today(tzone = "America/Phoenix") - lubridate::dyears(x = 2),
    format = "MM d, yyyy",
    startview = "month",
    weekstart = 0, # Sunday
    width = "100%",
    autoclose = TRUE
  ),
  
  shiny::dateInput(
    inputId = "endDate",
    label = "End Date",
    value = lubridate::today(tzone = "America/Phoenix") - 1,
    min = apiStartDate,
    max = lubridate::today(tzone = "America/Phoenix") - 1,
    format = "MM d, yyyy",
    startview = "month",
    weekstart = 0, # Sunday
    width = "100%",
    autoclose = TRUE
  ),
  
  shiny::actionButton(
    inputId = "retrieveData", 
    label = "RETRIEVE DATA",
    class = "btn btn-block btn-blue"
  )
) # bslib::sidebar()
