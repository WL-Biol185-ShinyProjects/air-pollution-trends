library(shiny)

airpollutiondata_clean <- read_excel("~/air-pollution-trends/airpollutiondata-clean.xlsx")

fluidPage(
  
  titlePanel("Air Pollution Info"),
  sidebarLayout(
    # Panel with widgets
    sidebarPanel(
      selectInput(inputId = 'Country',
                  label   = 'Select a Country',
                  choices = unique(airpollutiondata_clean$Country)
        
      ),
    uiOutput(outputId = "select_value")
    ),
    
    # Panel plot
    mainPanel(
      plotOutput('Pollution_Plot')
      
    )
    
  )
  
)