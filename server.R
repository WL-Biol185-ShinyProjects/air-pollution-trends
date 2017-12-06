library(shiny)
library(tidyverse)
library(ggplot2)
library(readxl)
library(dplyr)

CountryDataClean <- read_excel("~/air-pollution-trends/CountryDataClean.xls")
region <- read_excel("~/air-pollution-trends/CountryDataClean.xls")
countryGEO <- rgdal:: readOGR("countries.geo.json", "OGRGeoJSON")
airpollutiondata_clean <- read_excel("~/air-pollution-trends/airpollutiondata-clean.xlsx")


function(input, output) {
  
  output$Pollution_Plot <- renderPlot({
    
    CountryDataClean %>%
      filter(Country %in% input$firstCountry, Region %in% input$firstRegion) %>%
      ggplot(aes(Country, PM2.5)) + 
      geom_bar(stat = "identity", fill = "lightsteelblue3") +
      theme(text = element_text(size =20),
            axis.text.x = element_text(angle = 45, hjust = 1, size = 15)) 
    
  })
  


  output$select_value <- renderUI({
    
    selectInput(inputId = 'firstCountry',
                label   = 'Select a Country',
                choices = unique(filter(CountryDataClean, Region %in% input$firstRegion)$Country),
                selected = "Africa",
                multiple = TRUE)
  })
  
  output$Pollution_Plot2 <- renderPlot({
    
    CountryDataClean %>%
      filter(Country %in% input$secondCountry, Region %in% input$secondRegion) %>%
      ggplot(aes(Country, PM10)) + 
      geom_bar(stat = "identity", fill = "lightsteelblue3") +
      theme(text = element_text(size =20),
            axis.text.x = element_text(angle = 45, hjust = 1, size = 15)) 
    
  })
  
  
  
  output$select_values <- renderUI({
    
    selectInput(inputId = 'secondCountry',
                label   = 'Select a Country',
                choices = unique(filter(CountryDataClean, Region %in% input$secondRegion)$Country),
                selected = "Africa",
                multiple = TRUE)
  })

#Plot with City Data and Table
  output$`country-city-plot` <- renderPlot({
    airpollutiondata_clean %>%
      filter(Region %in% input$region) %>%
      ggplot(aes(Country, `Annual mean ug/m3, PM10`, color = Region)) + geom_point()
  })
  
  output$`country-city-table` <- renderDataTable({
    airpollutiondata_clean %>%
      filter(Region %in% input$region)
  })
 
#Heatmap for Mortality Incidence by Country, from Years 2000:2015

  output$Map_Mortality <- renderLeaflet({
    
    

Mortality_Filtered <- Total_Mortality_Data %>% 
  filter_("Year" %in% input$Year) %>% 
  gather(`statistic`, `incidence`, 4:11) %>% 
  filter_('statistic' %in% input$statistic)

countryGEO@data <- countryGEO@data %>%
  left_join(Mortality_Filtered, by = c("name" = "Name"))

pal <- colorNumeric("YlOrRd", c(0, 1247))
leaflet(data = countryGEO) %>%
  addTiles(options = tileOptions(noWrap = TRUE)) %>%
  setView( lng = 0, lat = 0, zoom = 2) %>%
  addPolygons(
    fillColor = ~pal(incidence)
    , weight = 5
    , opacity = 0.1
    , fillOpacity = 0.8
  ) 

  })


}





