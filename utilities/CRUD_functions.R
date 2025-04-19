import("dplyr")
import("DBI")
import("RSQLite")

consts <- use("constants.R")

#ELIMINAR UN REGISTRO POR DNI
deleteByDNI <- function(table, dni){
  # Connect to the database
  db <- dbConnect(SQLite(), consts$sqlitePath)
  # Construct the fetching query
  query <- sqlInterpolate(db,
                          sprintf("DELETE FROM %s WHERE dni = ?id1", table),
                          id1 = dni)
  # Submit the fetch query and disconnect
  data <- dbExecute(db, query)
  dbDisconnect(db)
  return(data)
}

#verifica si el dni introducido es valido
isValidDNI <- function(value){
  val <- T
  if(nchar(as.character(value)) != 8){
    val <- F
  }
  if(!grepl("\\D", as.character(val))){
    val <- F
  }
  return(val)
}

#funcion para guardar datos
saveData <- function(table, data) {
  # Connect to the database
  db <- dbConnect(SQLite(), consts$sqlitePath)
  a <- c()
  # Generar y ejecutar la sentencia INSERT INTO dentro de una transacción
  dbBegin(db)
  tryCatch({
    for (i in 1:nrow(data)) {
      a <- sqlInterpolate(db,
                          sprintf("INSERT INTO %s (%s) VALUES (?id1, ?id2, ?id3, ?id4, ?id5)",
                                  table,
                                  paste(names(data), collapse = ", ")
                          ),
                          id1 = data[i, 1],
                          id2 = data[i, 2],
                          id3 = data[i, 3],
                          id4 = data[i, 4],
                          id5 = data[i, 5])
      dbExecute(db, a)
    }
    dbCommit(db)
  }, error = function(e) {
    dbRollback(db)
    stop("Transaction failed: ", e$message)
  })
  dbDisconnect(db)
  return(as.character(a))
}

#funcion que valida si el csv tiene el formato deseado
isValidCSV <- function(df){
  val <- T
  if(!is.data.frame(df)){ #es un data frame?
    val <- F
  }
  if(any(duplicated(df$dni))){ # si hay dni duplicados
    val <- F
  }
  if(!(ncol(df) == 5)){ #tiene que haber 5 columnas
    val <- F
  }
  if(("" %in% df$dni)){ #no debe haber valores vaciones en el campo dni
    val <- F
  }
  if(val){ #si hasta este punto el df es valido
    aux <- loadData("personas") #cargo los registros existentes en db
    if(any(df$dni %in% aux$dni)){ #si alguno de los registros tiene un dni existente en la db, entonces va a haber duplicados.
      val <- F
    }
  }
  return(val)
}

#funcion de búsqueda en tabla a partir del dni
searchByDNI <- function(table, dni){
  # Connect to the database
  db <- dbConnect(SQLite(), consts$sqlitePath)
  # Construct the fetching query
  query <- sqlInterpolate(db,
                          sprintf("SELECT * FROM %s WHERE dni = ?id1", table),
                          id1 = dni)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  return(data)
}


#funcion para cargar datos
loadData <- function(table) {
  # Connect to the database
  db <- dbConnect(SQLite(), consts$sqlitePath)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- dbGetQuery(db, query)
  rownames(data) <- data$dni
  dbDisconnect(db)
  return(data)
}




























