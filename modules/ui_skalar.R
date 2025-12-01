ui_skalar <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      selectInput(ns("analyte"), "Select Analyte", choices = NULL),
      uiOutput(ns("reagent_ui")),
      numericInput(ns("target_volume"), "Target Final Volume (mL)", 
                   value = NA, min = 1),
      tags$br(),
      tags$body("Fill the required chemicals up to the target volume using 
                deionized water.")
    ),
    mainPanel(
      tags$h4("Reagent recalculation"),
      tags$body("Select the reagent to be prepared for the Skalar BluVision 
                Discrete Analyzer and specify the desired volume. The required
                quantities of the respective chemicals will be automatically
                recalculated."),
      tags$br(),
      verbatimTextOutput(ns("validation_msg")),
      tableOutput(ns("recalculated_table"))
    )
  )
}