calculate_c_V <- function(c1, V1, x2 = NULL, y2 = NULL) {
  
    y2 = (c1 * V1) / x2

  return(y2)
}


calculate_dilution_equidist <- function(steps_concentrations = NULL,
                                        target_V,
                                        stock_sol_conc,
                                        steps,
                                        lowest_conc,
                                        highest_conc
                                        ) {
  
  if(is.null(steps_concentrations)) {
    steps_concentrations <- seq(lowest_conc, highest_conc, length.out = steps)
  }
  
  stock_sol_V <- vector(mode = "numeric")
  for (n in 1:length(steps_concentrations)) {
    stock_sol_V[n] <- calculate_c_V(c1 = steps_concentrations[n],
                                    V1 = target_V,
                                    x2 = stock_sol_conc)
  }
  
  result <- tibble(`Volume stock solution [mL]` = stock_sol_V,
                   `Volume water [mL]` = target_V - stock_sol_V,
                   `Final concentration [mg/L]` = steps_concentrations)
  
  return(result)
}



# Function to convert a chemical formula given as character string to 
# a vector of the elements so that the mass function from the PeriodicTable 
# package can replace the elements with the respective molar mass.
convert_formula <- function(formula) {
  # Funktion zur Verarbeitung von Teilformeln
  process_subformula <- function(subformula, multiplier = 1) {
    matches <- gregexpr("[A-Z][a-z]?\\d*|\\([A-Za-z0-9]*\\)\\d*", subformula)
    substrings <- regmatches(subformula, matches)[[1]]
    
    elements <- c()
    
    for (substring in substrings) {
      if (grepl("^\\(", substring)) { # Teilformel in Klammern
        # Extrahiere den Inhalt der Klammern und den nachfolgenden Multiplikator
        inner_formula <- gsub("^\\((.*)\\)\\d*$", "\\1", substring)
        inner_multiplier <- as.numeric(gsub("^.*\\)(\\d*)$", "\\1", substring))
        if (is.na(inner_multiplier)) inner_multiplier <- 1
        elements <- c(elements, process_subformula(inner_formula, inner_multiplier * multiplier))
      } else { # normales Element
        element <- gsub("\\d", "", substring)
        count <- as.numeric(gsub("[A-Za-z]", "", substring))
        if (is.na(count)) count <- 1
        elements <- c(elements, rep(element, count * multiplier))
      }
    }
    
    return(elements)
  }
  
  return(process_subformula(formula))
}



# Function to calculate either n or m based on the choice of the user,
# an input value provided by the user, and M which is calculated based on
# the chemical formula that is provided by the user.
calculate_n_m <- function(input_value,
                          M,
                          n_or_m) {
  output <- vector(mode = "numeric")
  if(n_or_m == "n") {
    output <- input_value * M
  } else {
    output <- input_value / M
  }
  
  return(output)
}




custom_plot_theme <- function(base_size = 14) {
  theme_classic(base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", size = base_size + 2, hjust = 0.5),
      axis.title = element_text(size = base_size),
      axis.text = element_text(size = base_size - 2),
      legend.title = element_text(size = base_size),
      legend.text = element_text(size = base_size - 2),
      panel.grid.major = element_line(color = "grey80"),
      panel.grid.minor = element_blank()
    )
}




check_selection <- function(data, anal, reag) {
  unique_V <- data %>% 
    filter(
      analyte == anal &
        reagent == reag
    ) %>% 
    distinct(V_specified_by_skalar)
  
  return(nrow(unique_V) == 1)
}



recalculate_selection <- function(data, anal, reag, V_target) {
  data %>% 
    filter(
      analyte == anal &
        reagent == reag
    ) %>% 
    group_by(chemical, sum, unit) %>% 
    summarise(
      quantity = quantity * (V_target / V_specified_by_skalar)
    )
}

