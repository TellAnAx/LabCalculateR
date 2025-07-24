ui_molconv <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        textInput(ns("sum_formula"), "Sum formula", value = "H", width = "100%"),
        radioButtons(ns("n_or_m"), "Given:", choices = c("Mole" = "n", "Mass" = "m")),
        numericInput(ns("input_number"), "Value", value = 1, min = 0)
      ),
      mainPanel(
        textOutput(ns("mass"), container = tags$h3),
        textOutput(ns("mole_or_mass"), container = tags$h3)
      )
    )
  )
}
