server <- function(input, output) {
  
# TAB MOLCONVERTER
  
  molar_mass <- reactive({
    sum(map_dbl(convert_formula(input$sum_formula), ~ mass(.x)))
  })
  
  result <- reactive({
    calculate_n_m(input_value = input$input_number,
                  M = molar_mass(),
                  n_or_m = input$n_or_m)
  })
  
  output$mass <- renderText({
    paste("One mole of", input$sum_formula, 
          "has a mass of", molar_mass(), "grams.")
  })
  
  output$mole_or_mass <- renderText({
    paste("Result:", result())
  })
  
  
  
  
  
# TAB CONCENTRATION----
  output$numeric_output <- renderText({
    paste("The resulting concentration is", 
          calculate_c_V(c1 = input$c1, V1 = input$V1, x2 = input$x2))
  })
  
  
  
  
  
# TAB EQUIDISTANT DILUTION----
  result_table <- reactive({
    calculate_dilution_equidist(steps = input$n_steps,
                                target_V = input$target_volume,
                                stock_sol_conc = input$conc_stock,
                                lowest_conc = input$conc_lowest,
                                highest_conc = input$conc_highest)
  })
  
  
  output$resultTable <- renderTable({result_table()},
                                    striped = TRUE,
                                    bordered = TRUE,
                                    align = "c",
                                    width = "100%")
  
  
  output$resultPlot <- renderPlot({
    result_table() %>% 
      ggplot(aes(x = 1:input$n_steps, y = `Final concentration [mg/L]`)) +
      geom_col(fill = "lightblue") +
      labs(x = "Calibration standard No.",
           y = "Concentration [mg/L]") +
      theme_minimal() +
      theme(
        text = element_text(size = 14)
      )
  })
}