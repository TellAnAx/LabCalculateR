#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(tibble)
library(plotly)

source("R/helper_functions.R")
source("R/server.R")
source("R/ui.R")

# Run the application 
shinyApp(ui = ui, server = server)
