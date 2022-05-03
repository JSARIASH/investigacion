# PPP: precio promedio ponderado. 

library(tidyverse)
library(readxl)
library(lubridate)

contratos <- read_xlsx(
  path = "0_raw_data/Energía_Precios_Contratos_Promedios/EnergiaPreciosContratos_Mensuales.xlsx", 
  sheet = 1, col_names = TRUE, col_types = c("date", rep("numeric", 4)))

contratos$Mes <- ymd(contratos$Mes)

colnames(contratos) <- c("Fecha", "Regulados_Gwh", "Regulados_COP", "NoRegulados_Gwh", "NoRegulados_COP")

contratos <- contratos[complete.cases(contratos), ]

watts <- contratos %>% select(c(1, 2, 4)) %>% pivot_longer(
  cols = 2:3, 
  names_to = c("Usuario"), 
  values_to = "Gwh", 
  names_pattern = "([No]*Regulados)_Gwh"
)

cop <- contratos %>% select(c(1, 3, 5)) %>% pivot_longer(
  cols = 2:3, 
  names_to = "Usuario", 
  values_to = "COP/Kwh-PPP",
  names_pattern = "([No]*Regulados)_COP"
)

contratos <- inner_join(cop, watts, by = c("Fecha", "Usuario"))
write_csv(contratos, file = "2_data_results/ppp_mensual_contratos_2000_2022.csv", col_names = TRUE)


ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.09) + theme_linedraw() + 
  ylab(label = expression("$"*"/"*Kwh)) + 
  geom_line(data = contratos, 
            aes(x = Fecha, y = `COP/Kwh-PPP`, group = Usuario, colour = Usuario), 
            inherit.aes = FALSE, size = 0.8) +
            scale_color_manual(values = c("#59c7f2", "#AC6BFF"))


## Ejemplos: 
# https://tidyr.tidyverse.org/articles/pivot.html

billboard %>% 
  pivot_longer(
   cols = starts_with("wk"), names_to = "semana", 
   values_to = "rank", values_drop_na = TRUE
   )

billboard %>% 
  pivot_longer(
    cols = starts_with("wk"), names_to = "semana", 
    names_transform = list(semana = readr::parse_number),
    values_to = "rank", values_drop_na = TRUE,
    
  )

# La expresión regular solo deja los ‘‘Matching groups ()’’ lo que este por 
# fuera de estos grupos los elimina. 
who %>% pivot_longer(
  cols = new_sp_m014:newrel_f65,
  names_to = c("diagnóstico", "genero", "edad"), 
  values_to = "valor", 
  names_pattern = "new_?(.*)_(.)(.*)" 
)

