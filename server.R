# Funcion principal server

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #funcion para cargar datos
  loadData <- function(table) {
    # Connect to the database
    db <- dbConnect(SQLite(), sqlitePath)
    # Construct the fetching query
    query <- sprintf("SELECT * FROM %s", table)
    # Submit the fetch query and disconnect
    data <- dbGetQuery(db, query)
    rownames(data) <- data$dni
    dbDisconnect(db)
    return(data)
  }
  
  
  MAIN_row_delete <- reactive({
    input$MAIN_row_delete
  })
  
  MAIN_table_reload <- reactive({
    input$MAIN_table_reload
  })
  
  MAIN_row_create <- reactive({
    input$MAIN_row_create
  })
  
  #valor que guarda los registros disponibles en la db
  dbdata <- reactiveVal(loadData('personas'))
  
  
  foxTable$init_server("foxTable",
                       df = dbdata,
                       d = MAIN_row_delete,
                       r = MAIN_table_reload,
                       a = MAIN_row_create
                       )
  
  foxAbout$init_server("foxAbout",
                       df = about)
  

  #####################################################################
  # Función REGISTROS SELECCIONADOS
  #####################################################################

  DNIselectedList <- reactive({
    rownames(dbdata())[input$dbtable_rows_selected]
  })

  output$DEBUG_ROWS_SELECTED <- renderText({
    DNIselectedList()
  })
  
}


