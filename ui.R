library(shiny)
library(leaflet)
library(shinythemes)
library(shinydashboard)
library(htmltools)
CountryDataClean <- read_excel("~/air-pollution-trends/CountryDataClean.xls")


dashboardPage(skin = "green",
  dashboardHeader(title ="Air Pollution and Respiratory Illness"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Background", tabName = "background"),
      menuItem("Air Pollution Plots", tabName = "air-pollution-plots" ),
      menuItem("Mortaility Heat Map", tabName = "Mortality-Heat-Map"),
      menuItem("Sources", tabName = "sources")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidPage(
                titlePanel("World Air Pollution and Respiratory Illness Trends"),
                h5("Welcome to our webpage.")
              )
              ),
      
      tabItem(tabName = "background",
              fluidPage(
                titlePanel("Some background information on our project"),
                h5("djasjdjasjdja")
              )
              ),
      
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
      
      tabItem(tabName = "Mortality-Heat-Map",
          fluidPage(
            sliderInput(inputId ="Year",
                        label = "Year",
                        value = 2000,
                        min = 2000,
                        max = 2015,
                        step = 5,
                        animate = TRUE),
            titlePanel("Mortality Heat Map"),
          leafletOutput("Map_Mortality", width = 1000, height = 1000)
) ),

      tabItem(tabName = "sources",
          fluidPage(
            titlePanel("Sources"),
            br(),
            a(href = "http://www.who.int/healthinfo/global_burden_disease/estimates/en/index1.html", "World Country Mortality Data"),
            br(),
            a(href = "http://apps.who.int/gho/data/view.main.SDGPM25116v?lang=en", "World Country Air Pollution Data")
            
          )    
        )
      )  
)
)

