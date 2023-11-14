# Define UI for application that draws a histogram
ui <- fluidPage(
  ## Window title
  tags$head(
    tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov.png")),
  
  # App title ----
  titlePanel(title =  div(img(src="logo_frov.png"), tags$h1("LabCalculateR")), 
             windowTitle = "LabCalculateR"), 
  
  #tags$text("Equidistant calibration"),
  #tags$h2("Calculation of dilution series"),
  tags$p("This Shiny app facilitates the preparation of an equidistant dilution series to create a calibration curve."),
  
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
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)