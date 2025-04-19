#importar bibliotecas
import("shiny")
import("DT")
import("dplyr")
#exportar funciones principales
export("ui")
export("init_server")


ui <- function(id){
  ns <- NS(id)
  div(class = "tabset-info",
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel(
                    textOutput(ns("tab_1")),
                    div(class = "info-project-text",
                        
                        
                        div(
                          class = "logo-info",
                          HTML(
                            "<img src='assets/logo_foxAdmin.png' alt='logo' style='width:286px;height:156px;'>"
                          ),
                          div(
                            class = "logo-desc",
                            strong("Versión"), "v1.0",
                            br(),
                            strong("Fecha"), "2024-12-07",
                            br()
                          ),
                          div(class = "pal-info",)
                          
                        )
                        
                        )
                  ),
                  
                  tabPanel(
                    textOutput(ns("tab_2")),
                    div(class = "info-project-text",
                        
                        DTOutput(ns("foxAbout"))
                        #DTOutput(ns("foxAbout"), width = "100%", height = "600px")
                        
                    )
                  )
                  
                  )
      
      
      
      )
  
}

init_server <- function(id, df){
  callModule(server, id, df)
}

server <- function(input, output, session, df){
  #texto de las pestañas
  output$tab_1 <- renderText({
    
    "La aplicación"
    
  })
  output$tab_2 <- renderText({
    
    "Componentes utilizados"
    
  })
  #tabla de componentes utilizados
  output$foxAbout <- renderDT({
    
    aux <- df %>%
      filter(tipo != "datos") %>%
      select(recurso, version, licencia, enlaces)
    
    
    datatable(
      aux,  filter = 'none', rownames = F,
      options = list(
        columnDefs = list(list(className = 'dt-left', targets = c(0, 1, 2))),
        ordering=F,
        autoWidth = TRUE,
        scrollX = TRUE,
        pageLength = 18,
        lengthChange = F,
        searching = F
      ),
      escape = FALSE,
      selection = "none",
      class = "display nowrap compact"
      
    )
    
  }
  )
  
}





