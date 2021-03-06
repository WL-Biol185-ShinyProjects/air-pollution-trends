library(shiny)
library(leaflet)
library(shinythemes)
library(shinydashboard)
library(htmltools)
library(readxl)

CountryDataClean <- read_excel("CountryDataClean.xls")
airpollutiondata_clean <- read_excel("airpollutiondata-clean.xlsx")
airpollutiondata_clean$`1854` = NULL
Total_Mortality_Data <- read_excel("Total_Mortality_Data.xlsx")


dashboardPage(skin = "green",
  dashboardHeader(title ="Air Pollution and Respiratory Illness", titleWidth = 350),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("Background", tabName = "background"),
      menuItem("Air Pollution Plots", tabName = "air-pollution-plots" ),
      menuItem("Table and Chart with City Pollution", tabName = "cityplots"),
      menuItem("Mortaility Heat Map", tabName = "Mortality-Heat-Map"),
      menuItem("Sources", tabName = "sources")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidPage(
                titlePanel("World Air Pollution and Respiratory Illness Trends"),
                img(src = "industry.png",
                    height = 300,
                    width = 400,
                    align = "center"),
                tags$b(),
                h3("Welcome to our Air Pollution Trend application!"),
                  tags$br(),
                h4("This app allows you to explore various data describing indicators of air pollution.  The data can be broken down by World Region, Country, and even City!",
                    tags$br(),
                    tags$br(),
                  "We also provide an interactive world map for you to explore mortality rates due to respiratory diseases. You can select various respiratory diseases and infections and see their mortality rates on the map. You can adjust the year by changing the slider bar. There is a play button on the slider bar which animates a timelapse of the rates over 15 years.",
                    tags$br(),
                    tags$br(),
                   "The global population is rapidly growing and air pollution is becoming increasingly worse throughout the world. 
                    As a result, we wanted to investigate possible relationships between air pollution severity and rates of mortality due to respiratory diseases. 
                    Our goal is to provide easily accessible information regarding air pollution trends in a straightforward fashion.",
                    tags$br(),
                    tags$br(),
                  "We utilized data made available from the World Health Organization (WHO) to create this application."
                  )
              )),
      
      tabItem(tabName = "background",
              fluidPage(
                titlePanel("Some Background Information on our Project"),
                h4("Air pollution is a form of contamination that occurs when harmful substances are introduced to Earth’s atmosphere.",
                   tags$br(),
                   tags$br(),
                   "Common sources of harmful contaminates include motor vehicles (i.e. Cars, airplanes, trains, etc.), factories, and even forest fires.",
                   tags$br(),
                   tags$br(),
                   "Particulate Matter (PM) describes the mixture of solid and liquid particles found in the air and is used to characterize the severity of air pollution in a given area.",
                   tags$br(),
                   tags$br(),
                   tags$b("PM10"), "is a measure of particles with diameters of 10 micrometers or smaller while", tags$b("PM2.5"), "measures finer particles with diameters of 2.5 micrometers or less(1).  
                   Particulate Matter can be a major health concern and can lead to potentially fatal respiratory diseases(2).",
                   tags$br(),
                   tags$br(),
                   "Health consequences due to air pollution can range from simpler problems such as irritated eyes and throat 
                   to more serious issues such as Respiratory Infections, Asthma, Chronic Obstructive Pulmonary Disease (COPD), and even Pulmonary Cancer for example Mesothelioma(3).",
                   tags$br(),
                   tags$br(),
                   tags$a(href = "https://www.epa.gov/pm-pollution/particulate-matter-pm-basics", "1. EPA Particulate Matter Basics"),
                   tags$br(),
                   tags$a(href = "http://www.who.int/topics/air_pollution/en/", "2. World Health Organization Air Pollution"),
                   tags$br(),
                   tags$a(href = "https://www.environmentalpollutioncenters.org/air/diseases/", "3. Environmental Pollution Centers - Air Pollution Diseases!")
                   )
              )),
      
      tabItem(tabName = "air-pollution-plots",
              fluidRow(
                box(position = "above", width = 12, selectInput(inputId = 'firstRegion',
                                label   = 'Select a Region',
                                choices = unique(CountryDataClean$Region),
                                multiple = TRUE),
                    uiOutput(outputId = "select_value"),
               
                     tabPanel("PM 2.5 Air Pollution Bar Plot",    
                    plotOutput("Pollution_Plot"),
                  
              
                 box(position = "below", width = 20, selectInput(inputId = 'secondRegion',
                                  label   = 'Select a Region',
                                  choices = unique(CountryDataClean$Region),
                                  multiple = TRUE),
                    uiOutput(outputId = "select_values"),
                  
                     tabPanel("PM 10 Air Pollution Bar Plot",
                    plotOutput("Pollution_Plot2")
                
                  ) 
                ) 
              )  
          )  
       
     
  )
  ),
      tabItem(tabName = "cityplots",
              fluidPage(
                box(width = 12, 
                    checkboxGroupInput("region",
                                       label = "Region",
                                       choices = unique(airpollutiondata_clean$Region),
                                       selected = "AMR HI")),
                box(width = 12,
                    strong("Plot of PM10 for Cities within Countries"),
                    plotOutput("country_city_plot")),
                box(width = 12,
                    strong("Output Table of Data"),
                    dataTableOutput("country_city_table"))
              )),
  
      tabItem(tabName = "Mortality-Heat-Map",
          fluidPage(
            sliderInput(inputId ="Year",
                        label = "Year",
                        value = 2000,
                        min = 2000,
                        max = 2015,
                        step = 5,
                        animate = TRUE),
            selectInput(inputId = "statistic",
                        choices = colnames(Total_Mortality_Data)[4:11],
                        label = "Select a cause of Mortality"),
            
            
            titlePanel("Mortality Heat Map"),
          leafletOutput("Map_Mortality", width = 1000, height = 1000)
) ),

      tabItem(tabName = "sources",
          fluidPage(
            titlePanel("Sources"),
            br(),
            a(href = "http://www.who.int/healthinfo/global_burden_disease/estimates/en/index1.html", "World Country Mortality Data"),
            br(),
            a(href = "http://apps.who.int/gho/data/view.main.SDGPM25116v?lang=en", "World Country Air Pollution Data"),
            br(),
            a(href = "https://pixabay.com/en/industry-sunrise-sky-air-pollution-1752876/", "Picture")
            
          )    
        )
      )  
))

