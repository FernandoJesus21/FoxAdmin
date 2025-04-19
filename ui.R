#Función principal UI


# carga de constantes
consts <- use("constants.R")

ui <- fluidPage(

  div(class = "tabset-general",
      
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Inicio",
          htmlTemplate(
            "www/inicio.html",
            appTitle = 'Inicio',
            dashboardLogo = consts$shinyLogo,
            foxTable = foxTable$ui("foxTable"),
            MAIN_table_reload = actionButton("MAIN_table_reload", "Actualizar tabla"),
            MAIN_row_create = actionButton("MAIN_row_create", "Añadir registros"),
            MAIN_row_delete = actionButton("MAIN_row_delete", "Eliminar registro")
          )
        ),
        
        tabPanel(
          "Acerca de...",
          htmlTemplate(
            "www/acerde.html",
            appTitle = 'Acerca de...',
            dashboardLogo = consts$shinyLogo,
            foxAbout = foxAbout$ui("foxAbout")
          )
        )
        
      )
      
  )
  

  
  
)





































