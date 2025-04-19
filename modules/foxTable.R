
#importar bibliotecas
import("shiny")
import("DT")
import("dplyr")
import("DBI")
import("utils")
import("RSQLite")
#exportar funciones principales
export("ui")
export("init_server")

#carga de script con funciones CRUD
expose("utilities/CRUD_functions.R")
#carga de constantes
consts <- use("constants.R")


ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      class = "panel-header table-header",
      div(class = "item", "Registros encontrados"),
    ),
    div(
      class = "chart-table-container",
      DTOutput(ns("table"))
      #DTOutput(ns("table"), width = "100%", height = "600px")
    )
  )
}


init_server <- function(id, df, d, r, a) {
  callModule(server, id, df, d, r, a)
}

server <- function(input, output, session, df, d, r, a) {
  
  #definicion del namespace del lado del server para que el modulo funcione correctamente
  ns <- session$ns
  
  #####################################################################
  # Función ELIMINAR REGISTRO
  #####################################################################
  
  #cuando el usuario pulsa el boton 'Eliminar registro', se construye la ui especificada
  observeEvent(d(), {
    showModal(modalDialog(
      title = "Eliminar registro",
      textInput(session$ns("ROW_DELETE_dni_input"), label = consts$MSG_DNI_INPUT),
      textOutput(session$ns("ROW_DELETE_message")),
      actionButton(session$ns("ROW_DELETE_submit"), "Eliminar"),
      output$ROW_DELETE_message <- renderText({ "" }),
      easyClose = TRUE,
      footer = NULL
    ))
  }, ignoreInit = TRUE)

  #observador del boton de eliminar registros
  observeEvent(input$ROW_DELETE_submit, {
    if(!isValidDNI(input$ROW_DELETE_dni_input)){
      output$ROW_DELETE_message <- renderText({ consts$MSG_INVALID_DNI })
    }else{
      if(input$ROW_DELETE_dni_input %in% df()$dni){
        deleteByDNI('personas', input$ROW_DELETE_dni_input)
        output$ROW_DELETE_message <- renderText({ consts$MSG_DETELED_ROW })
      }else{
        output$ROW_DELETE_message <- renderText({ consts$MSG_DNI_NOT_FOUND })
      }

    }
  })

  #####################################################################
  # Función RECARGA DE TABLA
  #####################################################################
  
  #observador del boton de actualizacion de tabla
  observeEvent(r(), {
    df(loadData('personas'))
  })
  
  
  #####################################################################
  # Función AGREGAR REGISTRO
  #####################################################################
  
  #cuando el usuario pulsa el boton 'Añadir registro', se construye la ui especificada
  observeEvent(a(), {
    showModal(modalDialog(
      title = "Añadir registro",
      "Opción 1: Agregar registro manualmente:",
      textInput(session$ns("ROW_CREATE_dni_input"), label = "DNI"),
      radioButtons(session$ns("sex_input"), choices = c("M", "F"), inline = T, selected = "M", label = "Género"),
      textInput(session$ns("form_input"), label = "nombre"),
      textInput(session$ns("last_name_input"), label = "apellido"),
      textInput(session$ns("age_input"), label = "edad"),
      actionButton(session$ns("ROW_CREATE_submit"), "Subir datos"),
      textOutput(session$ns("ROW_CREATE_message")),
      output$ROW_CREATE_message <- renderText({ "" }),
      "Opción 2: Cargar registros desde un archivo .csv:",
      fileInput(session$ns("ROW_CREATE_csv_input"), "Elegir archivo CSV", accept = ".csv"),
      actionButton(session$ns("ROW_CREATE_submit_csv"), "Subir CSV"),
      textOutput(session$ns("ROW_CREATE_message_csv")),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  #cuando el usuario ingreso previamente a 'Añadir registro' y pulsa el botón 'subir datos'
  observeEvent(input$ROW_CREATE_submit, {
    if(!isValidDNI(input$ROW_CREATE_dni_input)){
      output$ROW_CREATE_message <- renderText({ "El DNI ingresado no es válido." })
    }else{
      if(nrow(searchByDNI("personas", input$ROW_CREATE_dni_input)) == 1 ){
        output$ROW_CREATE_message <- renderText({ consts$MSG_INVALID_DNI })
      }else{
        input_data <- data.frame("dni" = input$ROW_CREATE_dni_input,
                                 "sexo" = input$sex_input,
                                 "nombre" = input$form_input,
                                 "apellido" = input$last_name_input,
                                 "edad" = input$age_input)
        saveData("personas", input_data)
        output$ROW_CREATE_message <- renderText({ consts$MSG_SUCCESS_SAVE })
      }
    }
  })
  
  #data frame reactivo que contiene los datos subidos del archivo csv
  csv_data <- reactive({
    file <- input$ROW_CREATE_csv_input
    ext <- tools::file_ext(file$datapath)

    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))

    data <- read.csv(file$datapath, header = T)
  })
  
  
  #observador de la funcion de carga de datos mediante csv
  observeEvent(input$ROW_CREATE_submit_csv, {
    if(is.null(input$ROW_CREATE_csv_input)){
      output$ROW_CREATE_message_csv <- renderText({ consts$MSG_CSV_NOT_FOUND })
    }else{
      if(isValidCSV(csv_data())){
        saveData("personas", csv_data())
        output$ROW_CREATE_message_csv <- renderText({ consts$MSG_SUCCESS_SAVE_CSV })
      }else{
        output$ROW_CREATE_message_csv <- renderText({ consts$MSG_ERROR_CSV })
      }
    }
    unlink(input$ROW_CREATE_csv_input$datapath)
  })
  
  #####################################################################
  # Función RENDERIZAR TABLA
  #####################################################################
  
  output$table <- renderDT({
    
    aux <- df() %>%
      mutate(across(everything(), as.character))
    
    datatable(
      aux,
      extensions = c('Buttons', "FixedColumns", "FixedHeader", "Scroller"),
      options = list(
        dom = 'Bfrtip',
        lengthMenu = list(c(5, 15,-1), c('5', '15', 'All')),
        pageLength = 15,
        buttons = list(
          list(
            extend = "collection",
            text = paste0("15 registros"),
            action = DT::JS(
              "function ( e, dt, node, config ) {
                                    dt.page.len(15);
                                    dt.ajax.reload();
                                }"
            )
          ),
          list(
            extend = "collection",
            text = paste0("50 registros"),
            action = DT::JS(
              "function ( e, dt, node, config ) {
                                    dt.page.len(50);
                                    dt.ajax.reload();
                                }"
            )
          ),
          list(
            extend = "collection",
            text = "Mostrar todo",
            action = DT::JS(
              "function ( e, dt, node, config ) {
                                    dt.page.len(-1);
                                    dt.ajax.reload();
                                }"
            )
          ),
          "excel",
          "csv",
          "pdf"
        )
      ),
      filter = list(position = 'top', clear = FALSE),
      class = "display nowrap compact"
    ) %>% DT::formatStyle(columns = names(aux), color="#5C3E3E")
    
  })
}