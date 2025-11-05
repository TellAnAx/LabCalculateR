ui_skalar <- function(id) {
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      selectInput(ns("analyte"), "Select Analyte", choices = NULL),
      uiOutput(ns("reagent_ui")),
      numericInput(ns("target_volume"), "Target Final Volume (mL)", value = 100, min = 1)
    ),
    mainPanel(
      verbatimTextOutput(ns("validation_msg")),
      tableOutput(ns("recalculated_table"))
    )
  )
}