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
  # Use regular expression to match elements and their counts
  matches <- gregexpr("[A-Z][a-z]?\\d*", formula)
  
  # Extract matched substrings
  substrings <- regmatches(formula, matches)[[1]]
  
  # Initialize an empty vector to store the elements
  elements <- c()
  
  # Loop through the substrings and extract elements and counts
  for (substring in substrings) {
    element <- gsub("\\d", "", substring)  # Extract element
    count <- as.numeric(gsub("[A-Za-z]", "", substring))  # Extract count, if any
    
    # If no count is specified, default to 1
    count[is.na(count)] <- 1
    
    # Repeat the element according to its count and append to the vector
    elements <- c(elements, rep(element, count))
  }
  
  return(elements)
}
