server_molconv <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    molar_mass <- reactive({
      sum(map_dbl(convert_formula(input$sum_formula), ~ mass(.x)))
    })
    
    result <- reactive({
      calculate_n_m(
        input_value = input$input_number,
        M = molar_mass(),
        n_or_m = input$n_or_m
      )
    })
    
    output$mass <- renderText({
      paste("One mole of", input$sum_formula, 
            "has a mass of", molar_mass(), "grams.")
    })
    
    output$mole_or_mass <- renderText({
      paste("Result:", result())
    })
    
  })
}
