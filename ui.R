library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  #Application title
  titlePanel("Particulate Matter Data"),
  
  #Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 600,
                  value = 200)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

