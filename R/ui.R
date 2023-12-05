# Define UI for application that draws a histogram
ui <- fluidPage(
  
  #tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov.png")),
  titlePanel(title =  div(#img(src="logo_frov_small.png"), 
                          "LabCalculateR"), windowTitle = "LabCalculateR"), 
  
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
    tabPanel("Concentration", fluid = TRUE,
             inputPanel(
               numericInput("c1", "Concentration 1", value = 1),
               numericInput("V1", "Volume 1", value = 1),
               numericInput("x2", "Concentration or Volume 2", value = 1)
               #radioButtons("cV", "What would you like to calculate?", choices = c("Concentration 2" = "c2", "Volume 2" = "V2"))
             ),
             sidebarLayout(
               sidebarPanel(textOutput("numeric_output")),
               mainPanel(
                 p("Mathematical equation:"),
                 withMathJax("$$c_{1} V_{1} = c_{2} V_{2}$$")
               )
             )
    )
  ),
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)