ui_kpi <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      
      sidebarPanel(
        width = 2,
        h4("Enter calibration data"),
        uiOutput(ns("dynamic_inputs")),
        tags$hr(),
        fluidRow(
          column(6, actionButton(ns("submit"), "Calculate", class = "btn-primary")),
          column(6, actionButton(ns("reset"), "Reset", class = "btn-secondary"))
        )
      ),
      
      
      mainPanel(
        width = 10,
        fluidRow(
          column(
            width = 10,
            h4("Regression"),
            plotOutput(ns("regression_plot")),
            plotOutput(ns("residual_plot"))
          ),
          column(
            width = 2,
            h4("Model Summary"),
            tableOutput(ns("model_summary")),
            tags$hr(),
            h4("Calibration data"),
            tableOutput(ns("output_data")),
            downloadButton(ns("download_report"), "Download PDF Report", class = "btn-success")
          )
        )
      )
    )
  )
}
