library(shiny)
library(tidyverse)
library(ggplot2)
library(readxl)

airpollutiondata_clean <- read_excel("~/air-pollution-trends/airpollutiondata-clean.xlsx")

function(input, output) {
  
  output$Pollution_Plot <- renderPlot({
    
    airpollutiondata_clean %>%
      filter(Country == input$Country, Region == input$Region) %>%
      ggplot(aes(`City/Town`, `Annual mean, ug/m3, PM2.5`)) + 
      geom_bar(stat = "identity") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
    
  })
  
  region <- read_excel("~/air-pollution-trends/region-country-data.xlsx")

  output$select_value <- renderUI({
    
    selectInput(inputId = 'Country',
                label   = 'Select a Country',
                choices = unique(filter(airpollutiondata_clean, Region == input$Region)$Country))
  })
  
}

