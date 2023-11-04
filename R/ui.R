# Define UI for application that draws a histogram
ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  
  # ROW 1
  fluidRow(
    column(width = 4,
           tags$img(src="frov_logo.jpg")
    ),
    column(width = 8,
           tags$h1("Calculation of calibration standard concentrations")
    )
  ),
  
  fluidRow(
    column(width = 4,
           tags$h3("Necessary information"),
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
    column(8,
      tableOutput("resultTable"),
      plotOutput("resultPlot")
    )
  )
)