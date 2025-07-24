ui_conccalc <- function(id) {
  ns <- NS(id)
  tagList(
    sidebarLayout(
      sidebarPanel(
        numericInput(ns("c1"), "Concentration 1", value = 1),
        numericInput(ns("V1"), "Volume 1", value = 1),
        numericInput(ns("x2"), "Concentration or Volume 2", value = 1)
      ),
      mainPanel(
        tags$h1("Output:"),
        textOutput(ns("numeric_output"), container = tags$p),
        tags$h3("Mathematical equation:"),
        withMathJax("$$c_{1} V_{1} = c_{2} V_{2}$$")
      )
    )
  )
}
