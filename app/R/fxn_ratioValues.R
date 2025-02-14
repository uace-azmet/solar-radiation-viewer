#' `fxn_ratioValues.R` Generate scatterplot of ratios of measured-to-theoretical values
#' 
#' @param inData - daily AZMet data from `dataELT()`
#' @param azmetStation - user-specified AZMet station
#' @return `ratioValues` - scatterplot of ratios of measured-to-theoretical values

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596


fxn_ratioValues <- function(inData, azmetStation) {
  
  dataOtherMonths <- inData %>% 
    dplyr::filter(
      datetime <= lubridate::today(tzone = "America/Phoenix") - 1 - lubridate::dyears(x = 1)
    )
  
  dataRecentMonths <- inData %>% 
    dplyr::filter(
      datetime > lubridate::today(tzone = "America/Phoenix") - 1 - lubridate::dyears(x = 1)
    ) %>% 
    dplyr::arrange(date_doy)
  
  ratioValues <- 
    plotly::plot_ly( # Points for `dataOtherMonths`
      data = dataOtherMonths,
      x = ~date_doy,
      y = ~sol_rad_total_ratio,
      type = "scatter",
      mode = "markers",
      marker = list(
        size = 8,
        color = "rgba(201, 201, 201, 1.0)",
        line = list(
          color = "rgba(152, 152, 152, 1.0)",
          width = 1
        )
      ),
      name = "Prior to last 12 months",
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>Ratio:</b>  ", sol_rad_total_ratio,
        "<br><b>Measured value:</b>  ", sol_rad_total, " MJ/m^2",
        "<br><b>Theoretical value:</b>  ", sol_rad_total_clearsky, " MJ/m^2",
        "<br><b>Measurement date:</b>  ", gsub(" 0", " ", format(datetime, "%b %d, %Y"))
      ),
      showlegend = TRUE
    ) %>%
    
    plotly::add_trace( # Points for `dataRecentMonths`
      data = dataRecentMonths,
      x = ~date_doy,
      y = ~sol_rad_total_ratio,
      type = "scatter",
      mode = "markers",
      marker = list(
        size = 8,
        color = "rgba(89, 89, 89, 1.0)",
        line = list(
          color = "rgba(13, 13, 13, 1.0)",
          width = 1
        )
      ),
      name = "Last 12 months",
      showlegend = TRUE
    ) %>%
    
   plotly::config(
      displaylogo = FALSE,
      displayModeBar = TRUE,
      modeBarButtonsToRemove = c(
        "autoScale2d",
        "hoverClosestCartesian", 
        "hoverCompareCartesian", 
        "lasso2d",
        "select"
      ),
      scrollZoom = FALSE,
      toImageButtonOptions = list(
        format = "png", # Either png, svg, jpeg, or webp
        filename = 
          paste0("AZMet ", azmetStation, " solar radiation viewer ratio values"),
        height = 500,
        width = 700,
        scale = 5
      )
    ) %>%
    
    plotly::layout(
      legend = list(
        orientation = "h",
        traceorder = "reversed",
        x = 0.00,
        xanchor = "left",
        xref = "container",
        y = 1.05,
        yanchor = "bottom",
        yref = "container"
      ),
      margin = list(
        l = 0,
        r = 50, # For space between plot and modebar
        b = 80, # For space between x-axis title and caption or figure help text
        t = 0,
        pad = 0
      ),
      modebar = list(
        bgcolor = "#FFFFFF",
        orientation = "v"
      ),
      xaxis = list(
        title = list(
          font = list(size = 13),
          standoff = 25,
          text = "Day of Year"
        ),
        zeroline = FALSE
      ),
      yaxis = list(
        title = list(
          font = list(size = 13),
          standoff = 25,
          text = "Total Solar Radiation (MJ/m^2)"
        ),
        zeroline = FALSE
      )
    )
  
  return(ratioValues)
}
