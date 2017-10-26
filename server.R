library(shiny)
library(tidyverse)
library(ggplot2)
library(readxl)

CountryDataClean <- read_excel("~/air-pollution-trends/CountryDataClean.xls")

function(input, output) {
  
  output$Pollution_Plot <- renderPlot({
    
    CountryDataClean %>%
      filter(Country %in% input$Country, Region %in% input$Region) %>%
      ggplot(aes(Country, PM2.5)) + 
      geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
    
  })
  
  region <- read_excel("~/air-pollution-trends/CountryDataClean.xls")

  output$select_value <- renderUI({
    
    selectInput(inputId = 'Country',
                label   = 'Select a Country',
                choices = unique(filter(CountryDataClean, Region %in% input$Region)$Country),
                selected = "Africa",
                multiple = TRUE)
  })
  
}

