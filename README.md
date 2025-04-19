# FoxAdmin
 
PoC de un CRUD implementado en R Shiny. 

Originalmente destinado como interfaz de un sistema de registro de personas. Permite guardar registros según su identificación (dni), nombre, apellido, sexo y edad utilizando una base de datos SQLite.

![alt text](https://github.com/FernandoJesus21/FoxAdmin/blob/main/foxadmin.png?raw=true)

Se incluye un dataset con datos de prueba en /data

# Tech stack

- R Shiny
- HTMLTemplate
- SCSS
- Modules
- SQLite

# Puntos clave

1) Creación manual de registros
2) Agregar múltiples registros a partir de un .csv
3) Eliminación de registros
4) Actualización de tabla de los registros
5) Exportar datos como CSV, PDF o XLS.

# Detalles

Probado bajo entornos Windows y GNU/Linux con R 4.4.2

- En Windows requiere de [rtools](https://cran.r-project.org/bin/windows/Rtools/) para la instalación de algunas bibliotecas.
- En GNU/Linux la instalación de algunas bibliotecas de R puede requerir la instalación previa de paquetes del sistema.

Una vez clonado el repositorio, ejecutar renv::restore() o renv::install() para instalar todas las bibliotecas requeridas para el proyecto.

# Créditos

A [Appsilon](https://www.appsilon.com/) por el desarrollo de la plantilla '*shiny enterprise dashboard*' utilizada como base para este proyecto.