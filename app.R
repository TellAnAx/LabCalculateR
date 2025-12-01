source("global.R")

source("R/helper_functions.R")

source("modules/ui_kpi.R")
source("modules/ui_equidist.R")
source("modules/ui_conccalc.R")
source("modules/ui_molconv.R")
source("modules/ui_skalar.R")

source("modules/server_kpi.R")
source("modules/server_equidist.R")
source("modules/server_conccalc.R")
source("modules/server_molconv.R")
source("modules/server_skalar.R")






ui <- fluidPage(
  titlePanel(
    title = div("LabCalculateR"),
    windowTitle = "LabCalculateR"
  ),
  
  tabsetPanel(
    tabPanel("KPIs", ui_kpi("kpi")),
    tabPanel("Equidistant dilution", ui_equidist("equidistant")),
    tabPanel("Concentration", ui_conccalc("concentration")),
    tabPanel("Mole converter", ui_molconv("moleconverter")),
    tabPanel("Reagent converter", ui_skalar("skalar"))
  ),
  
  # FOOTER
  tags$br(), tags$br(),
  tags$text("You are using LabCalculateR v1.2.1"),
  tags$br(),
  tags$b("Written by:"),
  tags$a(href = "https://anil.tellbuescher.online", "Anıl Axel Tellbüscher"),
  tags$text(", University of South Bohemia, Czech Republic."),
  tags$br(),
  tags$b("Reporting issues:"),
  tags$text("Please report issues via"),
  tags$a(href = "https://github.com/TellAnAx/LabCalculateR/issues", "GitHub"),
  tags$text(" or contact the admin via email:"),
  tags$a(href = "mailto:admin@tellbuescher.online", "admin@tellbuescher.online"),
  tags$br(), tags$br()
)



server <- function(input, output, session) {
  server_kpi("kpi")
  server_equidist("equidistant")
  server_conccalc("concentration")
  server_molconv("moleconverter")
  server_skalar("skalar")
}


# Run the application 
shinyApp(ui = ui, server = server)
