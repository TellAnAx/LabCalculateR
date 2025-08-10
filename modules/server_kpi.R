
server_kpi <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    max_rows <- 10
    visible_rows <- reactiveVal(1)
    input_store <- reactiveValues()
    model_store <- reactiveVal(NULL)
    summary_store <- reactiveVal(NULL)
    
    
    # Helper: fallback for NULL values
    `%||%` <- function(a, b) if (!is.null(a)) a else b
    
    # Dynamically increase visible rows and store input values
    observe({
      current <- visible_rows()
      if (current < max_rows) {
        conc_val <- input[[paste0("conc_", current)]]
        response_val <- input[[paste0("response_", current)]]
        
        input_store[[paste0("conc_", current)]] <- conc_val
        input_store[[paste0("response_", current)]] <- response_val
        
        if (!is.null(conc_val) && !is.na(conc_val) &&
            !is.null(response_val) && !is.na(response_val)) {
          visible_rows(current + 1)
        }
      }
    })
    
    # Render dynamic input fields with preserved values
    output$dynamic_inputs <- renderUI({
      lapply(1:visible_rows(), function(i) {
        fluidRow(
          column(5, numericInput(
            ns(paste0("conc_", i)),
            label = if (i == 1) "Conc." else NULL,
            value = isolate(input_store[[paste0("conc_", i)]] %||% NA),
            min = 0
          )),
          column(5, numericInput(
            ns(paste0("response_", i)),
            label = if (i == 1) "Response" else NULL,
            value = isolate(input_store[[paste0("response_", i)]] %||% NA)
          ))
        )
      })
    })
    
    # Reset logic----
    observeEvent(input$reset, {
      for (i in 1:max_rows) {
        updateNumericInput(session, paste0("conc_", i), value = NA)
        updateNumericInput(session, paste0("response_", i), value = NA)
        input_store[[paste0("conc_", i)]] <- NA
        input_store[[paste0("response_", i)]] <- NA
      }
      
      visible_rows(1)
      
      output$input_data <- renderTable(NULL)
      output$model_summary <- renderTable(NULL)
      output$calplot <- renderPlot(NULL)
    })
    
    # Submit logic----
    observeEvent(input$submit, {

      n <- visible_rows()
      conc_vals <- purrr::map_dbl(1:n, ~ input[[paste0("conc_", .x)]])
      response_vals <- purrr::map_dbl(1:n, ~ input[[paste0("response_", .x)]])
      
      
      input_data <- tibble(conc = conc_vals, response = response_vals)
      
      print("Input data generated successfully!")
      print(input_data)
      
      output$input_data <- renderTable({
        input_data
      })
      
      
      
      model_data <- input_data %>% drop_na()
      
      print("Model data generated successfully!")
      print(model_data)
      
      
      
      output$regression_plot <- renderPlot({
        plot_object <- model_data %>% 
          ggplot(aes(x = conc, 
                     y = response)) + 
          geom_point() + 
          geom_smooth(method = "lm") + 
          labs(x = "concentration",
               y = "response") +
          custom_plot_theme()
        
        ggsave("www/regression_plot.png", 
               plot = plot_object, 
               width = 17, height = 10.7, units = "cm")
        
        plot_object
      })
      
      
      
      model <- lm(response ~ conc, 
                  data = model_data)
      
      print("Model generated successfully!")
      print(summary(model))
      
      
      
      slope <- coef(model)[["conc"]]
      intercept <- coef(model)[["(Intercept)"]]
      r_squared <- summary(model)$r.squared
      
      # Residual standard deviation
      residual_std <- sd(residuals(model))
      
      # LOD and LOQ
      LOD <- 3.3 * residual_std / slope
      LOQ <- 10 * residual_std / slope
      
      
      model_store(model)
      summary_store(list(
        slope = slope,
        intercept = intercept,
        r_squared = r_squared,
        lod = LOD,
        loq = LOQ,
        p_slope = summary(model)$coefficients["conc", "Pr(>|t|)"],
        p_intercept = summary(model)$coefficients["(Intercept)", "Pr(>|t|)"]
      ))
      
      
      
      # Summary table
      model_summary <- tibble(
        Metric = c("Slope", "Intercept", "R-squared", "LOD", "LOQ"),
        Value = c(slope, intercept, r_squared, LOD, LOQ)
      )
      
      print("Model summary generated successfully!")
      print(model_summary)
      
      
      
      output$model_summary <- renderTable({
        model_summary
      })
      
      
      
      output_data <- model_data %>% 
        mutate(
          id = 1:nrow(model_data),
          prediction = predict(model),
          error_abs = response - prediction,
          error_rel = error_abs / prediction,
          error_perc = error_rel * 100
        )
      
      print("Output data generated successfully!")
      print(output_data)
      
      
      
      output$residual_plot <- renderPlot({
        plot_object <- output_data %>% 
          ggplot(aes(x = id, 
                     y = error_perc)) + 
          geom_hline(yintercept = 0, color = "blue", linetype = "dashed") + 
          geom_segment(aes(x = id, xend = id, y = 0, yend = error_perc),
                       linetype = "solid") +
          geom_point(color = "red") +
          labs(x = "cal. point",
               y = "error (%)") +
          custom_plot_theme()
        
        ggsave("www/residual_plot.png", 
               plot = plot_object, 
               width = 17, height = 10.7, units = "cm")
        
        plot_object
      })
      
      
      
      
      output$output_data <- renderTable({
        output_data %>% 
          drop_na() %>% 
          mutate(error_perc = paste0(round(error_perc, digits = 1), "%")) %>% 
          select(id, error_perc) %>% 
          rename(
            `Cal. point` = "id",
            `Error (%)` = "error_perc"
            )
      })
      
      
      

    })
    
    # Initial outputs----
    output$input_data <- renderTable({
      tibble(`Conc.` = "–", `Response` = "–")
    })
    
    output$model_summary <- renderTable({
      tibble(Metric = c("Slope", "Intercept", "R-squared", "LOD", "LOQ"),
             Value = rep("–", 5))
    })
    
    output$output_data <- renderTable({
      tibble(`Cal. point` = "–", `Error (%)` = "–")
    })
    
    output$regression_plot <- renderPlot({
      ggplot() + 
        labs(x = "concentration",
             y = "response") +
        custom_plot_theme()
    })
    
    output$residual_plot <- renderPlot({
      ggplot() + 
        geom_hline(yintercept = 0, color = "blue", linetype = "dashed") + 
        labs(x = "cal. point",
             y = "error (%)") +
        custom_plot_theme()
    })
    
    
    output$download_report <- downloadHandler(
      filename = function() {
        paste("calibration_report_", Sys.Date(), ".pdf", sep = "")
      },
      content = function(file) {
        s <- summary_store()
        if (is.null(s)) return(NULL)
        
        rmarkdown::render(
          input = "www/calibration_report_template.Rmd",
          output_file = file,
          params = list(
            slope = s$slope,
            intercept = s$intercept,
            r_squared = s$r_squared,
            lod = s$lod,
            loq = s$loq,
            p_slope = s$p_slope,
            p_intercept = s$p_intercept
          ),
          envir = new.env(parent = globalenv())
        )
      }
    )
    
    
    
  })
}
