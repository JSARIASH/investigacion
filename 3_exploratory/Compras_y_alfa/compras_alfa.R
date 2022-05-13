# Se busca responder a la pregunta: 
# ¿Hay relación entre el alfa y el precio de compra de la energía?

library(tidyverse)
library(lubridate)
library(readxl)
source(file = "7_parameters/alfas.R")

# SICEP: sistema centralizado de información de las convocatorias públicas. 
# Se registran los contratos que van al regulado y no regulado. 

contratos_sicep <- read_excel(
  path = "0_raw_data/SICEP_Contratos/Resumen_Productos_Adjudicados_SICEP.xlsx", 
  skip = 2, col_names = TRUE, col_types = c(rep("text", 14), rep("numeric", 3))
  )

nombres <- stringi::stri_trans_general(colnames(contratos_sicep), id = "Latin-ASCII")
nombres <- str_remove_all(nombres, "[\\(\\)]")
nombres <- str_replace_all(nombres, "\\s", "_")
colnames(contratos_sicep) <- nombres
contratos_sicep <- contratos_sicep %>% mutate_at(7:12, ymd) %>% mutate_at(13:14, ymd_hm)

#Se eliminan sas y empresas de servicios públicos:  S.A.S E.S.P.
# (PEREIRA)

contratos_sicep$Nombre_Corto <- str_remove_all(
  contratos_sicep$Nombre_Corto, 
  pattern = "(\\.?\\s?S?\\.A?\\.?S?\\s?E?\\.?S?\\.?P?\\.?)|(\\(PEREIRA\\))"
  )

# Todos los contratos se fueron al mercado regulado. 

contratos_alfas <- inner_join(
  alfas_comercializadoras, contratos_sicep, 
  by = c("comercializador" = "Nombre_Corto")
  ) %>% 
  select(c(1:2, 7, 9:10, 16:18)) %>% 
  mutate(
    dias_contratados = as.numeric(Fin_Periodo_Contratar - Inicio_Periodo_Contratar)
    )

# Cantidad de energía vs el precio. 
contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
ggplot(aes(Cantidad_Energia_Adjudicada_GWh, `Promedio_Ponderado_Convocatoria_COP/kWh`)) + 
  geom_point() + theme_linedraw() + xlab(label = "Demanda (Gwh)") + ylab(label = expression("Precio " * Cop/Kwh))

contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
  ggplot(aes(Cantidad_Energia_Adjudicada_GWh, `Promedio_Ponderado_Convocatoria_COP/kWh`, colour = alfas)) + 
  geom_point() + theme_linedraw() + xlab(label = "Demanda (Gwh)") + ylab(label = expression("Precio " * Cop/Kwh))


contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0, alfas < 0.4 | alfas > 0.8) %>% 
  ggplot(aes(Cantidad_Energia_Adjudicada_GWh, `Promedio_Ponderado_Convocatoria_COP/kWh`, colour = alfas)) + 
  geom_point() + theme_linedraw() + xlab(label = "Demanda (Gwh)") + ylab(label = expression("Precio " * Cop/Kwh))

# alfas vs precio

contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
  ggplot(aes(alfas, `Promedio_Ponderado_Convocatoria_COP/kWh`)) + 
  geom_point() + theme_linedraw() + xlab(label = expression(alpha)) + ylab(label = expression("Precio " * Cop/Kwh))

contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
  ggplot(aes(alfas, `Promedio_Ponderado_Convocatoria_COP/kWh`, colour = Cantidad_Energia_Adjudicada_GWh)) + 
  geom_point() + theme_linedraw() + xlab(label = expression(alpha)) + ylab(label = expression("Precio " * Cop/Kwh))

contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
  ggplot(aes(alfas, `Promedio_Ponderado_Convocatoria_COP/kWh`, size = Cantidad_Energia_Adjudicada_GWh)) + 
  geom_point(shape = 21, fill = "purple", position = "jitter", colour = "black") + theme_linedraw() + 
  xlab(label = expression(alpha)) + ylab(label = expression(italic(COP/Kwh))) +
  labs(size = "Energía adjudicada Gwh") + theme(legend.position = "bottom")


contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% 
  ggplot(
    aes(alfas, `Promedio_Ponderado_Convocatoria_COP/kWh`, colour = dias_contratados, size = Cantidad_Energia_Adjudicada_GWh)
  ) + 
  geom_point() + theme_linedraw() + 
  xlab(label = expression(alpha)) + ylab(label = expression(COP/Kwh)) +
  labs(size = "Energía adjudicada Gwh: ") + theme(legend.position="bottom", legend.justification = "left") + 
  theme(text = element_text(size = 16))


# Precio por comercializador

contratos_alfas %>% filter(Cantidad_Energia_Adjudicada_GWh > 0) %>% arrange(alfas) %>% 
ggplot(
  aes(x = comercializador, `Promedio_Ponderado_Convocatoria_COP/kWh`, size = Cantidad_Energia_Adjudicada_GWh)
 ) + geom_point(position = position_jitter(width = .2, height = 15)) + theme_linedraw() + scale_x_discrete(guide = guide_axis(n.dodge=2)) + 
 theme(legend.position = "bottom") + labs(size = "Energía adjudicada Gwh: ") + ylab("COP/Kwh") + xlab(label = "")
