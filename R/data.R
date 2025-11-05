# Data for Skalar UI
data <- read_csv(
  file = "skalar_reagents_chemicals.csv"
) %>% 
  rename_with(str_to_lower) %>% 
  select(!starts_with("..."))