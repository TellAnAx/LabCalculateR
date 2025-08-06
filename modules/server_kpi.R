
server_kpi <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    observeEvent(input$submit, {
      col1_vals <- sapply(1:10, function(i) input[[paste0("col1_", i)]])
      col2_vals <- sapply(1:10, function(i) input[[paste0("col2_", i)]])
      
      result_tbl <- tibble(Column1 = col1_vals, Column2 = col2_vals)
      
      output$tibble_output <- renderTable({
        result_tbl
      })
    })
  })
} 
