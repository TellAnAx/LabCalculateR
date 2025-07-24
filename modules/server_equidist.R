server_equidist <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    result_table <- reactive({
      calculate_dilution_equidist(
        steps = input$n_steps,
        target_V = input$target_volume,
        stock_sol_conc = input$conc_stock,
        lowest_conc = input$conc_lowest,
        highest_conc = input$conc_highest
      )
    })
    
    output$resultTable <- renderTable({
      result_table()
    }, striped = TRUE, bordered = TRUE, align = "c", width = "100%")
    
    output$resultPlot <- renderPlot({
      result_table() %>%
        ggplot(aes(x = 1:input$n_steps, y = `Final concentration [mg/L]`)) +
        geom_col(fill = "lightblue") +
        labs(x = "Calibration standard No.", y = "Concentration [mg/L]") +
        theme_minimal() +
        theme(text = element_text(size = 14))
    })
  })
}
