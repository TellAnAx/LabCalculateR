# LOAD PACKAGES----
library(shiny)
library(tidyverse)
library(plotly)
library(PeriodicTable)


# LOAD DATA----

# Data for Skalar UI
data <- read_csv(
  file = "data/skalar_reagents_chemicals.csv"
) %>% 
  rename_with(str_to_lower) %>% 
  rename(V_specified_by_skalar = "final volume (ml)") %>% 
  select(!starts_with("..."))

