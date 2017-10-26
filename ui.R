library(shiny)

CountryDataClean <- read_excel("~/air-pollution-trends/CountryDataClean.xls")

fluidPage(
  
  titlePanel("Air Pollution Info"),
  sidebarLayout(
    # Panel with widgets
    sidebarPanel(
      selectInput(inputId = 'Region',
                  label   = 'Select a Region',
                  choices = unique(CountryDataClean$Region),
                  multiple = TRUE
        
      ),
    uiOutput(outputId = "select_value")
    ),
    
    # Panel plot
    mainPanel(
      plotOutput('Pollution_Plot')
      
    )
      
  )
  
)
