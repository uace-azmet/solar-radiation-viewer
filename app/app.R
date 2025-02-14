# Shiny app to explore graphs that compare battery voltage with weather variables by AZMet station

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# Libraries
library(azmetr)
library(bslib)
library(bsicons)
library(dplyr)
library(htmltools)
library(lubridate)
library(magrittr)
library(plotly)
library(shiny)
library(tibble)
library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##_DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    
    sidebar = sidebar, # `scr04_sidebar.R`
    
    navsetCardTab, # `scr05_navsetCardTab.R`
    
    shiny::htmlOutput(outputId = "figureHelpText"),
    htmltools::br(),
    htmltools::br(),
    htmltools::br(),
    shiny::htmlOutput(outputId = "pageBottomText"),
    
    fillable = TRUE,
    fillable_mobile = FALSE,
    theme = theme, # `scr03_theme.R`
    lang = NULL,
    window_title = NA
  )
)


# Server --------------------

server <- function(input, output, session) {
  
  shiny::observeEvent(input$retrieveData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr06_datepickerErrorModal.R`
    }
  })
  
  dataELT <- shiny::eventReactive(input$retrieveData, {
    shiny::validate(
      shiny::need(
        expr = input$startDate <= input$endDate,
        message = FALSE
      )
    )
    
    idRetrievingData <- shiny::showNotification(
      ui = "Retrieving data . . .", 
      action = NULL, 
      duration = NULL, 
      closeButton = FALSE,
      id = "idRetrievingData",
      type = "message"
    )
    
    on.exit(shiny::removeNotification(id = idRetrievingData), add = TRUE)
    
    fxn_dataELT(
      azmetStation = input$azmetStation, 
      startDate = input$startDate, 
      endDate = input$endDate
    )
  })
  
  pageBottomText <- shiny::eventReactive(dataELT(), {
    fxn_pageBottomText()
  })
  
  figureHelpText <- shiny::eventReactive(dataELT(), {
    fxn_figureHelpText(
      azmetStation = input$azmetStation,
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  measuredValues <- shiny::reactive({
    fxn_measuredValues(
      inData = dataELT(),
      azmetStation = input$azmetStation
    )
  })
  
  ratioValues <- shiny::reactive({
    fxn_ratioValues(
      inData = dataELT(),
      azmetStation = input$azmetStation
    )
  })
  
  # Outputs -----
  
  output$figureHelpText <- shiny::renderUI({figureHelpText()})
  output$pageBottomText <- shiny::renderUI({pageBottomText()})
  output$measuredValues <- plotly::renderPlotly(measuredValues())
  output$ratioValues <- plotly::renderPlotly(ratioValues())
}


# Run --------------------

shiny::shinyApp(ui = ui, server = server)
