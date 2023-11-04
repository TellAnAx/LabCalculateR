calculate_c_V <- function(c1, V1, c2 = NULL, V2 = NULL) {
  
    V2 = (c1 * V1) / c2

  return(V2)
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
                                    c2 = stock_sol_conc)
  }
  
  result <- tibble(`Volume stock solution [mL]` = stock_sol_V,
                   `Volume water [mL]` = target_V - stock_sol_V,
                   `Final concentration [mg/L]` = steps_concentrations)
  
  return(result)
}
