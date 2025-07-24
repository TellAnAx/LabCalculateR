ui_equidist <- function(id) {
  ns <- NS(id)
  tagList(
    inputPanel(
      sliderInput(ns("n_steps"), "Number of calibration standards", value = 5, min = 1, max = 10),
      numericInput(ns("conc_lowest"), "Lowest concentration of calibration standards [mg/L]", value = 10),
      numericInput(ns("conc_highest"), "Highest concentration of calibration standards [mg/L]", value = 100),
      numericInput(ns("target_volume"), "Target volume of calibration standards [mL]", value = 100),
      numericInput(ns("conc_stock"), "Concentration of stock solution [mg/L]", value = 1000)
    ),
    sidebarLayout(
      sidebarPanel(tableOutput(ns("resultTable"))),
      mainPanel(plotOutput(ns("resultPlot")))
    )
  )
}
