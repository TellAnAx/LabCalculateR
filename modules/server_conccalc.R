server_conccalc <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    output$numeric_output <- renderText({
      paste("The resulting concentration is", 
            calculate_c_V(c1 = input$c1, V1 = input$V1, x2 = input$x2))
    })
    
  })
}
