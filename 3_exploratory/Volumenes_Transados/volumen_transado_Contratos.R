source(file = "6_tool_kit/set_up_rmakdown.R")
source(file = "6_tool_kit/toolkit_volumen_kwh.R")

rutas_contratos_kwh <- list.files(path = "0_raw_data/Compras_contratos_Kw/", full.names = TRUE)

# Inconsistencias en los datos. 
# El año 2020 tiene una columna de mercado. 


contratos_kwh_compras <- lapply(rutas_contratos_kwh[1:20], leer_contratos_kwh)

# Año 2020
contratos_2020 <- read_excel(
  path = rutas_contratos_kwh[21], 
  range = cell_limits(c(3, 1), c(NA, 27)), #Fila 3 col 1.  
  col_types = c("text", "text", "text", rep("numeric", 24)),
  .name_repair = reparar_nombre_columnas
)
# Eliminar el mercado. 
contratos_2020 <- contratos_2020[-3]
contratos_kwh_compras[[21]] <- contratos_2020


contratos_kwh_compras <- lapply(contratos_kwh_compras, reparar_fechas_contratos)

sapply(contratos_kwh_compras, colnames, simplify = TRUE)
sapply(contratos_kwh_compras, ncol)
 
do.call(rbind, contratos_kwh_compras)


