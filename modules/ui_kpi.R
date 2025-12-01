ui_kpi <- function(id) {
  ns <- NS(id)
  
  tagList(sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Enter calibration data"),
      rHandsontableOutput(
        ns("input_table"), 
        width = "100%", 
        height = "100%"),
      tags$hr(),
      
      fluidRow(
        actionButton(
          ns("submit"),
          "Calculate",
          class = "btn-primary",
          width = "100%"
        ),
        tags$br(),
        tags$br(),
        actionButton(
          ns("reset"), 
          "Reset", 
          class = "btn-secondary", 
          width = "100%")
      ),
      
      fluidRow(
        h4("Model Summary"),
        tableOutput(ns("model_summary")),
        tags$hr(),
        h4("Calibration data"),
        tableOutput(ns("output_data")),
        downloadButton(
          ns("download_report"),
          "Download PDF Report",
          class = "btn-success",
          width = "100%")
      )
    ),
    
    
    mainPanel(width = 9, fluidRow(
      h4("Regression"),
      plotOutput(ns("regression_plot")),
      h4("Residuals"),
      plotOutput(ns("residuals_plot"))
    ))
  ))
}
