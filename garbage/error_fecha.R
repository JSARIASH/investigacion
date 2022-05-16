source(file = "6_tool_kit/set_up_rmakdown.R")

# El origen en excel es el 30 de diciembre de 1899. 
# "1899-12-30". Esta es la fecha que se requiere para convertir un entero a 
# fecha. 

# El nombre de las columnas en read_excel se pasa como un vector. 
reparar_nombre_columnas <- function(x) {
  x <- tolower(gsub("[.]", "_", x))
  x <- gsub("\\s", "_", x)
  x <- stringi::stri_trans_general(x, id = "Latin-ASCII")
  numeros <- grepl("[0-9]+", x)
  x[numeros] <- paste0("h_", x[numeros])
  return(x)
  }



contratos <- read_excel(
  path = "9_data_test/Compras_Contrato_(kwh)_2000.xlsx", 
  range = cell_limits(c(3, 1), c(NA, 26)), 
  col_types = c("text", "text", rep("numeric", 24)),
  .name_repair = reparar_nombre_columnas
)

# Las fechas pueden estar en formato a-m-d o estar como un entero. 
fechas <- contratos$Fecha
pos_fechas_formato_ymd <- grep(fechas, pattern = "^20[0-9]+")
pos_fechas_formato_num <- grep(fechas, pattern = "^20[0-9]+", invert = TRUE)

fechas_corregidas <- vector(length = length(fechas)) 
class(fechas_corregidas) <- "Date"

fechas_corregidas[pos_fechas_formato_num] <- as.Date(as.numeric(fechas[fechas_formato_num]), origin = "1899-12-30")
fechas_corregidas[pos_fechas_formato_ymd] <- ymd(fechas[pos_fechas_formato_ymd])

