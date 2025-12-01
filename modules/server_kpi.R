
server_kpi <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    max_rows <- 10
    input_store <- reactiveValues()
    model_store <- reactiveVal(NULL)
    summary_store <- reactiveVal(NULL)
    
    
    # Data input table----
    output$input_table <- renderRHandsontable({
      rhandsontable(
        data = data.frame(
          "conc." = as.numeric(rep(NA, max_rows)), 
          "response" = as.numeric(rep(NA, max_rows))
          ),
        useTypes = TRUE,
        readOnly = FALSE,
        selectCallback = TRUE,
        search = FALSE
        )
    })
    
    
    
    # Reset logic----
    # observeEvent(input$reset, {
    #   for (i in 1:max_rows) {
    #     updateNumericInput(session, paste0("conc_", i), value = NA)
    #     updateNumericInput(session, paste0("response_", i), value = NA)
    #     input_store[[paste0("conc_", i)]] <- NA
    #     input_store[[paste0("response_", i)]] <- NA
    #   }
    #   
    # 
    #   output$input_data <- renderTable(NULL)
    #   output$model_summary <- renderTable(NULL)
    #   output$calplot <- renderPlot(NULL)
    # })
    
    
    
    # Submit logic----
    # After clicking on "Calculate"...
    observeEvent(input$submit, {

      # ...create a tibble with the input data
      input_data <- hot_to_r(input$input_table)
      
      print("Input data generated successfully!")
      print(input_data)
      
      
      #...render a table with the
      output$input_data <- renderTable({
        input_data
      })
      
      
      ## MODEL----
      model_data <- input_data %>% 
        rename(
          conc = "conc."
        ) %>% 
        drop_na()
      print("Model data generated successfully!")
      print(model_data)
      
  
      model <- lm(response ~ conc, 
                  data = model_data)
      print("Model generated successfully!")
      print(summary(model))
      
      
      ## KPIs----
      slope <- coef(model)[["conc"]]
      intercept <- coef(model)[["(Intercept)"]]
      r_squared <- summary(model)$r.squared
      
      # Standard deviation of residuals
      residual_std <- sd(residuals(model))
      
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
      
      
      model_summary <- tibble(
        Metric = c("Slope", "Intercept", "R-squared", "LOD", "LOQ"),
        Value = c(slope, intercept, r_squared, LOD, LOQ)
      )
      print("Model summary generated successfully!")
      print(model_summary)
      
      
      
      ## TABLES----
      
      output$model_summary <- renderTable({
        model_summary
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
      
      
      
      ## PLOTS----

      output$regression_plot <- renderPlot({
        plot_object <- model_data %>% 
          ggplot(aes(x = conc, 
                     y = response)) + 
          
          add_pred_band(model, model_data, "conc") +    # Vorhersageband
          add_conf_band(model, model_data, "conc") +    # Konfidenzband
          
          geom_point() + 
          geom_smooth(method = "lm", se = FALSE) + 
          labs(x = "Concentration",
               y = "Response") +
          scale_fill_manual(values = c("Confidence band" = "#4DB6AC", 
                                      "Prediction band" = "#7986CB")) +
          custom_plot_theme()
        
        ggsave("www/regression_plot.png", 
               plot = plot_object, 
               width = 17, height = 10.7, units = "cm")
        
        plot_object
      })
      
      
      output$residuals_plot <- renderPlot({
        plot_object <- output_data %>% 
          ggplot(aes(x = id, 
                     y = error_perc)) + 
          geom_hline(yintercept = 0, color = "blue", linetype = "dashed") + 
          geom_segment(aes(x = id, xend = id, y = 0, yend = error_perc),
                       linetype = "solid") +
          geom_point(color = "red") +
          labs(x = "Cal. point (no.)",
               y = "Error (%)") +
          custom_plot_theme()
        
        ggsave("www/residuals_plot.png", 
               plot = plot_object, 
               width = 17, height = 10.7, units = "cm")
        
        plot_object
      })
      
    })
    
    
    
    # BLANK OUTPUTS----
    output$model_summary <- renderTable({
      tibble(
        Metric = c("Slope", "Intercept", "R-squared", "LOD", "LOQ"),
        Value = rep("–", 5))
    })
    
    
    output$output_data <- renderTable({
      tibble(
        `Cal. point no.` = "–", 
        `Error (%)` = "–")
    })
    
    
    output$regression_plot <- renderPlot({
      ggplot() + 
        labs(
          x = "Concentration",
          y = "Response"
          ) +
        lims(
          x = c(0, 10),
          y = c(0, 10)
          ) +
        custom_plot_theme()
    })
    
    
    output$residuals_plot <- renderPlot({
      ggplot() + 
        geom_hline(
          yintercept = 0, 
          color = "blue", 
          linetype = "dashed") + 
        labs(
          x = "Cal. point (no.)",
          y = "Error (%)"
          ) +
        lims(
          x = c(0, 10),
          y = c(-10, 10)
          ) +
        custom_plot_theme()
    })
    
    
    
    # CAL. REPORT----
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
