# Define UI for application that draws a histogram
ui <- fluidPage(
  
  tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov.png")),
  titlePanel(title =  div(img(src="logo_frov_small.png"), "LabCalculateR"), windowTitle = "LabCalculateR"), 
  
  tabsetPanel(
    tabPanel("Equidistant dilution", fluid = TRUE,
      inputPanel(
        sliderInput("n_steps","Number of calibration standards",value = 5,min = 1,max = 10),
        numericInput("conc_lowest","Lowest concentration of calibration standards [mg/L]",value = 10),
        numericInput("conc_highest","Highest concentration of calibration standards [mg/L]",value = 100),
        numericInput("target_volume","Target volume of calibration standards [mL]",value = 100),
        numericInput("conc_stock","Concentration of stock solution [mg/L]",value = 1000)
        ),
      sidebarLayout(
        sidebarPanel(tableOutput("resultTable")),
        mainPanel(plotOutput("resultPlot"))
        )    
      ),
    tabPanel("Calibration analysis", fluid = TRUE,
             inputPanel(
               # Concentration input (vector)
               # Signal 1 input (vector)
               # Signal 2 input (vector)
               # Signal 3 input (vector)  
             ),
             sidebarLayout(
               sidebarPanel(
                 # calibration data output
                  ),
               mainPanel(
                 # calibration plot
                  )
                )
             )
  ),
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)