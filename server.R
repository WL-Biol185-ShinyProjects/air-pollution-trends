library(shiny)
library(tidyverse)
library(ggplot2)
library(readxl)
library(dplyr)

CountryDataClean <- read_excel("CountryDataClean.xls")
Total_Mortality_Data <- read_excel("Total_Mortality_Data.xlsx")
countryGEO <- rgdal:: readOGR("countries.geo.json", "OGRGeoJSON")
airpollutiondata_clean <- read_excel("airpollutiondata-clean.xlsx")
airpollutiondata_clean$`1854` = NULL

filterEqual <- function(x, columnName, value) {
  x[x[[columnName]] == value, ]
}
filterIn    <- function(x, columnName, values) {
  x[x[[columnName]] %in% values, ]
}

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
  output$country_city_plot <- renderPlot({
    airpollutiondata_clean %>%
      filterIn("Region", input$region) %>%
      ggplot(aes(Country, `Annual mean ug/m3, PM10`, color = Region)) + geom_point() +
      theme(text = element_text(size =20),
            axis.text.x = element_text(angle = 45, hjust = 1, size = 15)) 
  })
  
  output$country_city_table <- renderDataTable({
    airpollutiondata_clean %>%
      filterIn("Region", input$region)
  })

#Heatmap for Mortality Incidence by Country, from Years 2000:2015

  filteredCountryGEO <- reactive({
    Mortality_Filtered <- Total_Mortality_Data %>% 
      filterEqual("Year", input$Year) %>% 
      gather(`statistic`, `incidence`, 4:11) %>% 
      filterEqual("statistic", input$statistic)
    
    suppressWarnings(
      countryGEO@data <- countryGEO@data %>%
        left_join(Mortality_Filtered, by = c("name" = "Name")))
    
    countryGEO
  })
  
  output$Map_Mortality <- renderLeaflet({
    pal <- colorBin("YlOrRd", c(0, 1247), bins = 30)     
leaflet(data = filteredCountryGEO()) %>%
  addProviderTiles("CartoDB.Positron", options = tileOptions(noWrap = TRUE)) %>%
  setView( lng = 0, lat = 0, zoom = 2) %>%
  addPolygons(
    fillColor = ~pal(as.numeric(incidence))
    , weight = 1
    , opacity = 0.1
    , fillOpacity = 0.8
  )
  addLegend(pal = pal,
            values = incidence,
            opacity = 0.1,
            title = NULL,
            position = "bottomright")
  })

observe({
    pal <- colorBin("YlOrRd", c(0, 1247), bins = 30)
    
    leafletProxy("Map_Mortality", data = filteredCountryGEO()) %>%
      clearShapes() %>%
      addPolygons(
        fillColor = ~pal(as.numeric(incidence))
        , weight = 1
        , opacity = 0.1
        , fillOpacity = 0.8
      ) 
    addLegend(pal = pal,
              values = ~incidence,
              opacity = 0.1,
              title = NULL,
              position = "bottomright")
  })

}


