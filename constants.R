
#importa bibliotecas a utilizar
import("htmltools")

#nombre de la BD
sqlitePath <- "foxdb.sqlite"

#mensajes de acción
MSG_INVALID_DNI <- "El DNI ingresado no es válido."
MSG_DNI_INPUT <- "Introduzca un DNI"
MSG_ERROR_CSV <- "Ocurrió un error al cargar los datos del archivo. Verifique el formato e inténtelo de nuevo."
MSG_DETELED_ROW <- "Registro eliminado."
MSG_DNI_NOT_FOUND <- "DNI no encontrado."
MSG_CSV_NOT_FOUND <- "Archivo CSV no encontrado."
MSG_SUCCESS_SAVE_CSV <- "Archivo CSV cargado con éxito."
MSG_SUCCESS_SAVE <- "Registro cargado con éxito."
MSG_FOUND_DUPLICATED_DNI <- "Ya existe un registro con este DNI"

#este logo corresponde al logo de la aplicacion
shinyLogo <- HTML(
  "
   <img src='assets/logo_foxAdmin.png' alt='logo' style='width:111px;height:60px;'>
"
)











