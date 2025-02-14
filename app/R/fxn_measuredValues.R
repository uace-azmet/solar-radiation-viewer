#' `fxn_measuredValues.R` Generate scatterplot of measured values based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @return `measuredValues` - scatterplot of measured values based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596


fxn_measuredValues <- function(inData, azmetStation) {
  
  dataOtherMonths <- inData %>% 
    dplyr::filter(
      datetime <= lubridate::today(tzone = "America/Phoenix") - 1 - lubridate::dyears(x = 1)
    )
  
  dataRecentMonths <- inData %>% 
    dplyr::filter(
      datetime > lubridate::today(tzone = "America/Phoenix") - 1 - lubridate::dyears(x = 1)
    ) %>% 
    dplyr::arrange(date_doy)
  
  measuredValues <- 
    plotly::plot_ly( # Points for `dataOtherMonths`
      data = dataOtherMonths,
      x = ~date_doy,
      y = ~sol_rad_total,
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
        "<br><b>Measured value:</b>  ", sol_rad_total, " MJ/m^2",
        "<br><b>Measurement date:</b>  ", gsub(" 0", " ", format(datetime, "%b %d, %Y"))
      ),
      showlegend = TRUE
    ) %>%
    
    plotly::add_trace( # Points for `dataRecentMonths`
      data = dataRecentMonths,
      x = ~date_doy,
      y = ~sol_rad_total,
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
    
    plotly::add_trace( # Theoretical clear-sky solar radiation line
      data = dataRecentMonths,
      x = ~date_doy,
      y = ~sol_rad_total_clearsky, 
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(13, 13, 13, 1.0)", 
        width = 2
      ),
      name = paste0("Theoretical-clear-sky values"),
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>Theoretical value:</b>  ", sol_rad_total_clearsky, " MJ/m^2",
        "<br><b>Date:</b>  ", gsub(" 0", " ", format(datetime, "%b %d, %Y"))
      ),
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
        filename = "AZMet-solar-radiation-viewer-measured-values",
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
  
  return(measuredValues)
}
