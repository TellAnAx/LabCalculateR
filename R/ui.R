# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Calculation of calibration standard concentrations"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
    numericInput("conc_lowest",
                 "Lowest concentration [mg/L]",
                 value = 10),
    numericInput("conc_highest",
                 "Highest concentration [mg/L]",
                 value = 100),
    numericInput("target_volume",
                 "Target volume of calibration standards [mL]",
                 value = 100),
    numericInput("conc_stock",
                 "Concentration of stock solution [mg/L]",
                 value = 1000),
    sliderInput("n_steps",
                "Number of calibration standards",
                value = 5,
                min = 1,
                max = 10)
  ),
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("resultTable"),
      plotOutput("resultPlot")
    )
  )
)