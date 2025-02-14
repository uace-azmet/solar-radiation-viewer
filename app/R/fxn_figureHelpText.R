#' `fxn_figureHelpText.R` - Build help text for figure
#' 
#' @param azmetStation - user-specified AZMet station
#' @param startDate - Start date of period of interest
#' @param endDate - End date of period of interest
#' @return `figureHelpText` - Help text for figure


fxn_figureHelpText <- function(azmetStation, startDate, endDate) {
  figureHelpText <- 
    htmltools::p(
      htmltools::HTML(
        "Data are from the AZMet ", azmetStation, "station and from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y.")), " Hover over data for variable values and click or tap on legend items to toggle data visibility. Select from the icons to the right of the graph for additional functionality. Theoretical-clear-sky values are based on FAO Irrigation and Drainage Paper No. 56 - Crop Evapotranspiration and do not account for water vapor."
      ), 
      
      class = "figure-help-text"
    )
  
  return(figureHelpText)
}
