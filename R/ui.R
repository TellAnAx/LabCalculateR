# Define UI for application that draws a histogram
ui <- fluidPage(
  
  #tags$head(tags$link(rel = "icon", type = "image/png", sizes = "32x32", href = "logo_frov.png")),
  titlePanel(title =  div(#img(src="logo_frov_small.png"), 
                          "LabCalculateR"), windowTitle = "LabCalculateR"), 
  
  tabsetPanel(
    
    # EQUIDISTANT DILUTION SERIES----
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
    
    
    # CONCENTRATION CALCULATOR----
    tabPanel("Concentration", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 numericInput("c1", "Concentration 1", value = 1),
                 numericInput("V1", "Volume 1", value = 1),
                 numericInput("x2", "Concentration or Volume 2", value = 1)
               ),
               mainPanel(
                 tags$h1("Resulting concentration"),
                 textOutput("numeric_output")),
                 tags$h1("Mathematical equation"),
                 withMathJax("$$c_{1} V_{1} = c_{2} V_{2}$$")
             )
      ),
    
    
    # MOLE CONVERTER----
    tabPanel("Mole converter", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(
                 textInput("sum_formula", "Sum formula", value = "H", width = "100%"),
                 radioButtons("n_or_m", "Mole or Mass", choices = c("Mole" = "n", "Mass" = "m")),
                 numericInput("input_number", "Input value", value = 1)
                 ),
               mainPanel(
                 textOutput("mass", container = tags$h3)
                 )
             )
             )
  ),
  
  tags$footer("written by Anil A. Tellbuescher. Contact for troubleshooting: admin@tellbuescher.online")
)