
# Los nombres de las columnas inicia en 4 para los años antes de 1995. 
lectura_precio_bolsa <- function (x) {
  if (str_detect(x, pattern = "199[0-9]")) {
    dts <- read_excel(
      x, sheet = 1, range = "A4:Y370", 
      col_types = c("text", rep("numeric", 24)), col_names = TRUE
      )
  } else {
    dts <- read_excel(
      x, sheet = 1, range = "A3:Y370", 
      col_types = c("text", rep("numeric", 24)), col_names = TRUE
      )
  }
  return(dts)
}

# Nombre de las columnas. 

nombre_columnas <- function (x) {
  nombres <- colnames(x)
  nombres[2:25] <- paste0("p_", nombres[2:25])
  colnames(x) <- nombres
  return(x)
}
