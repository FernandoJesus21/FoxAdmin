
#carga de bibliotecas
library(shiny)
library(DBI)
library(readr)
library(RSQLite)
library(DT)
library(dplyr)
library(sass)
library(modules)

#carga y compilado de estilos 
sass(
  sass_file("styles/main.scss"),
  output = "www/main.css",
  options = sass_options(output_style = "compressed"),
  cache = NULL
)

#carga de modulos
foxTable <- use("./modules/foxTable.R")
foxAbout <- use("./modules/foxAbout.R")

#nombre de la BD
sqlitePath <- "foxdb.sqlite"

#conectar a la BD
db <- dbConnect(SQLite(), sqlitePath)

#creación de la tabla
dbExecute(db, "CREATE TABLE IF NOT EXISTS personas
(
  dni VARCHAR(20),
  sexo VARCHAR(1),
  nombre VARCHAR(20),
  apellido VARCHAR(20),
  edad VARCHAR(3)
);")

dbDisconnect(db)

#Archivo de creditos y componentes de terceros
about <-
  read_csv("www/data/csv/about.csv", show_col_types = FALSE) %>%
  mutate(enlaces = paste0("<a href='", enlaces, "'target='_blank'>", enlaces, "</a>"))













