# Define UI for application that draws a histogram
ui <- fluidPage(
  
  tags$h1("Equidistant calibration"),
  tags$h2("Calculation of dilution series"),
  
  sidebarLayout(
    sidebarPanel(
      tags$h3("Data input"),
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
    mainPanel(
      tableOutput("resultTable"),
      plotOutput("resultPlot")
      )
  ),
  
  tags$footer("written by Anıl A. Tellbüscher. Contact for troubleshooting: admin@tellbuescher.online")
)