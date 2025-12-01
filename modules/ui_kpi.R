ui_kpi <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      
      sidebarPanel(
        width = 2,
        h4("Enter calibration data"),
        rHandsontableOutput(ns("input_table")),
        tags$hr(),
        fluidRow(
          column(6, 
                 actionButton(ns("submit"), 
                              "Calculate", 
                              class = "btn-primary",
                              width = "100%")),
          tags$br(), tags$br(),
          column(6, 
                 actionButton(ns("reset"), 
                              "Reset", 
                              class = "btn-secondary",
                              width = "100%"))
        )
      ),
      
      
      mainPanel(
        width = 10,
        fluidRow(
          column(
            width = 10,
            h4("Regression"),
            plotOutput(ns("regression_plot")),
            h4("Residuals"),
            plotOutput(ns("residuals_plot"))
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
