enca <- c("fecha", "codigo_agente", paste0("h_", 0:23))

enca <- c("fecha", "codigo_agente", paste0("h_", 0:23))
compras_contratos <- read_excel(
  path = "../../0_raw_data/Compras_contratos_Kw/Compras_Contrato_(kwh)_2000.xlsx", 
  range = cell_limits(c(3, 1), c(NA, NA)), 
  col_types = c("date", "text", rep("numeric", 24))
)

read_excel(
        path = "0_raw_data/Compras_contratos_Kw/Compras_Contrato_(kwh)_2000.xlsx", 
        range = cell_limits(c(3, 1), c(NA, 1)), 
        col_types = "text"
      ) %>% pull
    

