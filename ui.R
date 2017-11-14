library(shiny)
library(leaflet)
library(shinythemes)
library(shinydashboard)

CountryDataClean <- read_excel("~/air-pollution-trends/CountryDataClean.xls")


dashboardPage(skin = "green",
  dashboardHeader(title ="Air Pollution and Respiratory Illness"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Air Pollution Plots", tabName = "air-pollution-plots"),
      menuItem("Respiratory Illness Heat Map", tabName = "Mortality Heat Map"),
      menuItem("City Heat Map", tabName = "city-heat-map"),
      menuItem("Country Heat Map", tabName = "country-heat-map")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidPage(
                titlePanel("World Air Pollution and Respiratory Illness Trends"),
                h5("Welcome to our webpage.")
              )),
      
      tabItem(tabName = "air-pollution-plots",
              fluidRow(
                box(position = "above", selectInput(inputId = 'firstRegion',
                                label   = 'Select a Region',
                                choices = unique(CountryDataClean$Region),
                                multiple = TRUE),
                    uiOutput(outputId = "select_value"),
                tabBox(width = 10,
                  tabPanel("PM 2.5 Air Pollution Bar Plot",
                  plotOutput("Pollution_Plot", width = 800, height = 400),
                  
              
                 box(position = "below", selectInput(inputId = 'secondRegion',
                                  label   = 'Select a Region',
                                  choices = unique(CountryDataClean$Region),
                                  multiple = TRUE),
                    uiOutput(outputId = "select_values"),
                tabBox(width = 20,
                    tabPanel("PM 10 Air Pollution Bar Plot",
                    plotOutput("Pollution_Plot2", width = 800, height = 400)
     
                          )
                        )
                      )
                    )
  )))
      ),
      tabItem(tabName = "Mortality Heat Map",
          fluidPage(
            titlePanel("Mortality Heat Map"),
          leafletOutput("Map_Mortality"), p(), actionButton("recalc", ""))
))))