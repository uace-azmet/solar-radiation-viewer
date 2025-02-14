navsetCardTab <- bslib::navset_card_tab(
  id = "navsetCardTab",
  selected = "measuredValues",
  title = NULL,
  sidebar = NULL,
  header = NULL,
  footer = NULL,
  height = 600,
  full_screen = TRUE,
  #wrapper = card_body,
  
  bslib::nav_panel(
    title = "Measured Values",
    value = "measuredValues",
    plotly::plotlyOutput("measuredValues")
  ),
  
  bslib::nav_panel(
    title = "Ratios of Measured to Theoretical Values",
    value = "ratioValues",
    plotly::plotlyOutput("ratioValues")
  )
) |>
  htmltools::tagAppendAttributes(
    #https://getbootstrap.com/docs/5.0/utilities/api/
    class = "border-0 rounded-0 shadow-none"
  )
