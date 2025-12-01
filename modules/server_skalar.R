server_skalar <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Populate analyte choices
    observe({
      updateSelectInput(session, "analyte", choices = unique(data$analyte))
    })
    
    # Reactive: Filter reagents based on selected analyte
    reagents_for_analyte <- reactive({
      req(input$analyte)
      data %>%
        filter(analyte == input$analyte) %>%
        pull(reagent) %>%
        unique()
    })
    
    # UI for reagent dropdown
    output$reagent_ui <- renderUI({
      selectInput(ns("reagent"), "Select Reagent", choices = reagents_for_analyte())
    })
    
    # Validation message
    output$validation_msg <- renderText({
      req(input$analyte, input$reagent)
      if (!check_selection(data, input$analyte, input$reagent)) {
        return("⚠️ Data is invalid: multiple final volumes found. Contact admin.")
      } else {
        return("✅ Data is valid.")
      }
    })
    
    # Recalculated table
    output$recalculated_table <- renderTable({
      req(input$analyte, input$reagent, input$target_volume)
      if (check_selection(data, input$analyte, input$reagent)) {
        recalculate_selection(data, input$analyte, input$reagent, input$target_volume) %>% 
          select(chemical, sum, quantity, unit) %>% 
          rename(`sum formula` = "sum") %>% 
          rename_with(str_to_title)
      } else {
        NULL
      }
    })
  })
}