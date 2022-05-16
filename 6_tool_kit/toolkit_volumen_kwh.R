# Lectura de los libros con información de la cantidad de enregía comprada en kwh 
# en contratos. 

# /home/sebastian/Documents/Doctorado/Código/0_raw_data/Compras_contratos_Kw

# El nombre de las columnas en read_excel se pasa como un vector. 
reparar_nombre_columnas <- function(x) {
  x <- tolower(gsub("[.]", "_", x))
  x <- gsub("\\s", "_", x)
  x <- stringi::stri_trans_general(x, id = "Latin-ASCII")
  numeros <- grepl("[0-9]+", x)
  x[numeros] <- paste0("h_", x[numeros])
  return(x)
}

# Se leen los datos con la información del volumen. 
leer_contratos_kwh <- function (x) {
  read_excel(
    path = x, 
    range = cell_limits(c(3, 1), c(NA, 26)), #Fila 3 col 1.  
    col_types = c("text", "text", rep("numeric", 24)),
    .name_repair = reparar_nombre_columnas
  )
}


# Función para corregir las fechas. 

# El origen en excel es el 30 de diciembre de 1899. 
# "1899-12-30". Esta es la fecha que se requiere para convertir un entero a 
# fecha. 

reparar_fechas_contratos <- function (x) {
  fechas <- x$fecha
  pos_fechas_formato_ymd <- grep(fechas, pattern = "^20[0-9]+")
  pos_fechas_formato_num <- grep(fechas, pattern = "^20[0-9]+", invert = TRUE)
  
  fechas_corregidas <- vector(length = length(fechas)) 
  class(fechas_corregidas) <- "Date"
  
  fechas_corregidas[pos_fechas_formato_num] <- as.Date(as.numeric(fechas[pos_fechas_formato_num]), origin = "1899-12-30")
  fechas_corregidas[pos_fechas_formato_ymd] <- ymd(fechas[pos_fechas_formato_ymd])
  
  x$fecha <- fechas_corregidas
  return(x)
}
