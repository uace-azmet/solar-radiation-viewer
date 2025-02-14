#' `fxn_timeSeries.R` Generate time series graph based on user input
#' 
#' @param inData - daily AZMet data from `dataAZMetDataELT()`
#' @param azmetStation - user-specified AZMet station
#' @param batteryVariable - user-specified battery variable
#' @param weatherVariable - user-specified weather variable
#' @return `timeSeries` - time series graphs based on user input

# https://plotly-r.com/ 
# https://plotly.com/r/reference/ 
# https://plotly.github.io/schema-viewer/
# https://github.com/plotly/plotly.js/blob/c1ef6911da054f3b16a7abe8fb2d56019988ba14/src/components/fx/hover.js#L1596


fxn_timeSeries <- function(
    inData, 
    azmetStation, 
    batteryVariable, 
    weatherVariable
  ) {
  
  dataOtherStations <- inData %>% 
    dplyr::filter(meta_station_name != azmetStation) %>%
    dplyr::group_by(meta_station_name)
  
  dataSelectedStation <- inData %>% 
    dplyr::filter(meta_station_name == azmetStation)
  
  batteryVariableTimeSeries <- 
    plotly::plot_ly( # Lines for `dataOtherStations`
      data = dataOtherStations,
      x = ~datetime,
      y = ~.data[[batteryVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(201, 201, 201, 1.0)", 
        width = 1
      ),
      name = "other station data",
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", batteryVariable, ":</b>  ", .data[[batteryVariable]],
        "<br><b>AZMet station:</b>  ", meta_station_name,
        "<br><b>Measurement date:</b>  ", gsub(" 0", " ", format(datetime, "%b %d, %Y"))
      ),
      showlegend = TRUE,
      legendgroup = "dataOtherStations"
    ) %>%
    
    plotly::add_trace( # Lines for `dataSelectedStation`
      data = dataSelectedStation,
      x = ~datetime,
      y = ~.data[[batteryVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(89, 89, 89, 1.0)", 
        width = 2
      ),
      name = paste0(azmetStation, " station data"),
      showlegend = FALSE,
      legendgroup = "dataSelectedStation"
    )
  
  weatherVariableTimeSeries <- 
    plotly::plot_ly( # Lines for `dataOtherStations`
      data = dataOtherStations,
      x = ~datetime,
      y = ~.data[[weatherVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(201, 201, 201, 1.0)", 
        width = 1
      ),
      name = "other station data",
      hoverinfo = "text",
      text = ~paste0(
        "<br><b>", weatherVariable, ":</b>  ", .data[[weatherVariable]],
        "<br><b>AZMet station:</b>  ", meta_station_name,
        "<br><b>Measurement date:</b>  ", gsub(" 0", " ", format(datetime, "%b %d, %Y"))
      ),
      showlegend = FALSE,
      legendgroup = "dataOtherStations"
    ) %>%
    
    plotly::add_trace( # Lines for `dataSelectedStation`
      data = dataSelectedStation,
      x = ~datetime,
      y = ~.data[[weatherVariable]],
      type = "scatter",
      mode = "lines",
      marker = NULL,
      line = list(
        color = "rgba(89, 89, 89, 1.0)", 
        width = 2
      ),
      name = paste0(azmetStation, " station data"),
      showlegend = TRUE,
      legendgroup = "dataSelectedStation"
    )
  
  timeSeries <- plotly::subplot(
    batteryVariableTimeSeries, 
    weatherVariableTimeSeries, 
    margin = 0.05,
    nrows = 2,
    shareX = TRUE
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
        filename = "AZMet-battery-voltage-viewer-time-series",
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
      #title = list( # to make a caption
      #  text = ~paste0("<i>Data are from ", gsub(" 0", " ", format(startDate, "%B %d, %Y")), " through ", gsub(" 0", " ", format(endDate, "%B %d, %Y")), ".<br>Click or tap on legend items to toggle data visibility.</i>"),
      #  font = list(
      #    color = "#989898",
      #    size = 14
      #  ),
      #  x = 0.0,
      #  xanchor = "left",
      #  xref = "container",
      #  y = 0.05,
      #  yanchor = "bottom",
      #  yref = "container"
      #),
      xaxis = list(
        title = list(
          font = list(size = 13),
          standoff = 25,
          text = "Date"
        ),
        zeroline = FALSE
      ),
      yaxis = list(
        title = list(
          font = list(size = 13),
          standoff = 25,
          text = batteryVariable
        ),
        zeroline = FALSE
      ),
      yaxis2 = list(
        title = list(
          font = list(
            size = 13
          ),
          standoff = 25,
          text = weatherVariable
        ),
        zeroline = FALSE
      )
    )
  
  return(timeSeries)
}
