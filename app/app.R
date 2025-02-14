# Shiny app to explore graphs that compare measured and theoretical-clear-sky solar radiation by AZMet station


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

# Functions. Loaded automatically at app start if in `R` folder
#source("./R/fxnABC.R", local = TRUE)

# Scripts. Loaded automatically at app start if in `R` folder
#source("./R/scr##_DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  filename = "azmet-shiny-template.html",
  
  pageSidebar = bslib::page_sidebar(
    title = NULL,
    
    sidebar = sidebar, # `scr##_sidebar.R`
    
    navsetCardTab, # `scr##_navsetCardTab.R`
    
    shiny::htmlOutput(outputId = "figureHelpText"),
    shiny::htmlOutput(outputId = "downloadButtonHelpText"),
    shiny::uiOutput(outputId = "downloadButtonCSV"),
    shiny::uiOutput(outputId = "downloadButtonTSV"),
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
  
  # Observables -----
  
  shiny::observeEvent(input$retrieveData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
    }
  })
  
  # Reactives -----
  
  absoluteValues <- shiny::reactive({
    fxn_absoluteValues(
      inData = dataELT(),
      azmetStation = input$azmetStation
    )
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
  
  downloadButtonHelpText <- shiny::eventReactive(dataELT(), {
    fxn_downloadButtonHelpText()
  })
  
  figureHelpText <- shiny::eventReactive(dataELT(), {
    fxn_figureHelpText(
      azmetStation = input$azmetStation,
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  pageBottomText <- shiny::eventReactive(dataELT(), {
    fxn_pageBottomText()
  })
  
  ratioValues <- shiny::reactive({
    fxn_ratioValues(
      inData = dataELT(),
      azmetStation = input$azmetStation
    )
  })
  
  # Outputs -----
  
  output$absoluteValues <- plotly::renderPlotly(absoluteValues())
  
  output$downloadButtonCSV <- renderUI({
    req(dataELT())
    downloadButton(
      "downloadCSV", 
      label = "Download .csv", 
      class = "btn btn-default btn-blue", 
      type = "button"
    )
  })
  
  output$downloadButtonHelpText <- renderUI({
    downloadButtonHelpText()
  })
  
  output$downloadButtonTSV <- renderUI({
    req(dataELT())
    downloadButton(
      "downloadTSV", 
      label = "Download .tsv", 
      class = "btn btn-default btn-blue", 
      type = "button"
    )
  })
  
  output$downloadCSV <- downloadHandler(
    filename = function() {
      paste0(
        "AZMet ", input$azmetStation, " solar radiation data ", input$startDate, " to ", input$endDate, ".csv"
      )
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = dataELT(), 
        file = file, 
        delim = ","
      )
    }
  )
  
  output$downloadTSV <- downloadHandler(
    filename = function() {
      paste0(
        "AZMet ", input$azmetStation, " solar radiation data ", input$startDate, " to ", input$endDate, ".tsv"
      )
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = dataELT(), 
        file = file, 
        delim = "\t"
      )
    }
  )
  
  output$figureHelpText <- shiny::renderUI({figureHelpText()})
  
  output$pageBottomText <- shiny::renderUI({pageBottomText()})
  
  output$ratioValues <- plotly::renderPlotly(ratioValues())
}


# Run --------------------

shiny::shinyApp(ui = ui, server = server)
