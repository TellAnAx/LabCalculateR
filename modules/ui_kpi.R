ui_kpi <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        h4("Enter values for the table"),
        lapply(1:10, function(i) {
          fluidRow(
            column(6, textInput(paste0("col1_", i), label = paste("Column 1, Row", i))),
            column(6, textInput(paste0("col2_", i), label = paste("Column 2, Row", i)))
          )
        }),
        actionButton("submit", "Create Tibble")
      ),
      mainPanel(
        tableOutput("tibble_output")
      )
    )
  )
}