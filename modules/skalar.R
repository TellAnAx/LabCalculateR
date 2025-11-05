data <- read_csv(
  file = "skalar_reagents_chemicals.csv"
  ) %>% 
  rename_with(str_to_lower) %>% 
  select(!starts_with("..."))

analytes <- unique(data$analyte)

reagents <- unique(data$reagent)


check_selection <- function(data, anal, reag) {
  unique_V <- data %>% 
    filter(
      analyte == anal &
        reagent == reag
    ) %>% 
    distinct(`final v (ml)`)
  
  return(nrow(unique_V) == 1)
}



check_selection(data, "Nitrate", "Color reagent")



recalculate_selection <- function(data, anal, reag, V_target) {
  data %>% 
    filter(
      analyte == anal &
        reagent == reag
    ) %>% 
    group_by(chemical, sum) %>% 
    summarise(
      `m (g) or V (mL)` = `m (g) or v (ml)` * (V_target / `final v (ml)`)
    )
}


recalculate_selection(data, "Nitrate", "Color reagent", 100)