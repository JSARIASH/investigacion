library(readxl)
library(readr)
library(dplyr)
library(ggplot2)
library(rmarkdown)
library(lubridate)
library(tidyr)
library(stringr)

datos_precio_bolsa <- read_csv(file = "2_data_results/precio_bolsa_1995_2022.csv", col_names = TRUE, 
                               col_types = list("D", "c", "d"))

contratos <- read_csv(file = "2_data_results/ppp_mensual_contratos_2000_2022.csv", col_names = TRUE, 
                      col_types = list("D", "c", "d", "d"))

# Facet_wrap
# Evolución del precio desde el 95 hasta 22 para cada hora
ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = precio)) + 
  geom_line() + theme_linedraw() + facet_wrap(~factor(hora, levels = unique(hora)), ncol = 4)

# Ordenar por hora. 

ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = precio)) + 
  geom_line(alpha = 1) + theme_linedraw() + 
  facet_wrap(~factor(hora, levels = unique(hora)), ncol = 4) 

# Gráficos de líneas 

# Evolución de los precios hora desde el 95. Las 0 desde el 95, 
ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.09) + theme_linedraw() + 
  ylab(label = expression("$"*"/"*Kwh))


# gráfico para las primeras 4 horas. 
datos_precio_bolsa %>% filter(hora %in% paste0("p_", 0:3)) %>%    
ggplot(aes(x = Fecha, y = precio, colour = hora)) + 
  geom_line(alpha = 1) + theme_linedraw() + 
  ylab(label = expression("$"*"/"*Kwh))

# Evolución del precio discriminado por hora. Una línea por año. 
datos_precio_bolsa %>% mutate(año = year(Fecha)) %>% group_by(año, hora) %>%
  mutate(indice = as.numeric(format(Fecha, "%j"))) %>% ungroup() %>% 
  ggplot(aes(indice, precio, group = interaction(año, hora), colour = año))+ 
  geom_line(alpha = 1) + 
  facet_wrap(~factor(hora, levels = unique(hora)), ncol = 4) + theme_linedraw()

# Se filtra por fecha menor a 2013
datos_precio_bolsa %>% filter(Fecha <= ymd("2013-01-01")) %>% mutate(año = year(Fecha)) %>% group_by(año, hora) %>%
  mutate(indice = as.numeric(format(Fecha, "%j"))) %>% ungroup() %>% 
  ggplot(aes(indice, precio, group = interaction(año, hora), colour = año))+ 
  geom_line(alpha = 1) + 
  facet_wrap(~factor(hora, levels = unique(hora)), ncol = 4) + theme_linedraw()

# Grafico de puntos
datos_precio_bolsa %>% mutate(año = year(Fecha)) %>% group_by(año, hora) %>%
  mutate(indice = as.numeric(format(Fecha, "%j"))) %>% ungroup() %>% 
  ggplot(aes(indice, precio, group = interaction(año, hora), colour = año))+ 
  geom_point(alpha = 1) + 
  facet_wrap(~factor(hora, levels = unique(hora)), ncol = 4) + theme_linedraw()

# Grafico. evolución del precio en la hora 0. 
datos_precio_bolsa %>% filter(hora == "p_0") %>% mutate(año = year(Fecha)) %>% group_by(año, hora) %>%
  mutate(indice = as.numeric(format(Fecha, "%j"))) %>% ungroup() %>% 
  ggplot(aes(indice, precio, group = interaction(año, hora), colour = año))+ 
  geom_point(alpha = 1, size = 0.7) + theme_linedraw() +
  xlab("Días") + ylab(expression("$"*"/"*Kwh))


# Líneas. 
ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = jitter(precio, amount = 20), group = hora)) + 
  geom_line(alpha = 0.09) + theme_linedraw() + 
  ylab(label = expression("$"*"/"*Kwh))


ggplot(data = datos_precio_bolsa, aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.07) + theme_linedraw() + 
  ylim(c(0, 2000)) + ylab(label = expression("$"*"/"*Kwh)) + 
  geom_rect(data = tibble(), 
            aes(xmin = ymd("2015-01-01"), xmax = ymd("2016-12-01"),
                ymin = -Inf, ymax = Inf
                ), inherit.aes = FALSE,
            colour = NA, alpha = 0.1, fill="red"
            )

# del 1995 al 2000
datos_precio_bolsa %>% filter(Fecha <= ymd("2000-01-01")) %>% 
ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 500)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango: 2000-01-01")

datos_precio_bolsa %>% filter(Fecha >= ymd("2000-01-01") &Fecha <= ymd("2005-01-01")) %>% 
  ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 500)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango 2000-01-01 a 2005-01-01")

datos_precio_bolsa %>% filter(Fecha >= ymd("2005-01-01") &Fecha <= ymd("2010-01-01")) %>% 
  ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 500)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango 2005-01-01 a 2010-01-01")

datos_precio_bolsa %>% filter(Fecha >= ymd("2010-01-01") & Fecha <= ymd("2015-01-01")) %>% 
  ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 500)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango 2010-01-01 a 2015-01-01")


datos_precio_bolsa %>% filter(Fecha >= ymd("2010-01-01") & Fecha <= ymd("2015-01-01")) %>% 
  ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 500)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango 2010-01-01 a 2015-01-01")

datos_precio_bolsa %>% filter(Fecha >= ymd("2015-01-01")) %>% 
  ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_line(alpha = 0.1) + theme_linedraw() + 
  ylim(c(0, 3000)) + ggtitle(label = "Comportamiento del precio", subtitle = "Rango: superior 2015")


# Se crea una varialbe para medir el tiempo como la cantidad de horas que ha pasado desde 20-07-1995
# para pintar el precio de forma continúa. 

datos_precio_bolsa %>% mutate(hora_dia = factor(hora, levels = c(unique(datos_precio_bolsa$hora)))) %>% 
  arrange(Fecha, hora_dia) %>% mutate(dia_entero = 1:nrow(datos_precio_bolsa)) %>% 
    ggplot(aes(dia_entero, precio)) + geom_line(alpha = 0.8) + theme_linedraw()

datos_precio_bolsa %>% mutate(hora_dia = factor(hora, levels = c(unique(datos_precio_bolsa$hora)))) %>% 
  arrange(Fecha, hora_dia) %>% 
  mutate(
    dia_entero = ymd_h(paste(Fecha, as.integer(str_extract(hora_dia, "[0-9]+"))))
    ) %>% 
  ggplot(aes(dia_entero, precio)) + geom_line(alpha = 1) + theme_linedraw() +
  geom_line(data = contratos %>% mutate(Fecha = ymd_h(paste(Fecha, 0))), 
            aes(x = Fecha, y = `COP/Kwh-PPP`, group = Usuario, colour = Usuario), 
            inherit.aes = FALSE, size = 0.8) +
  scale_color_manual(values = c("#59c7f2", "#AC6BFF"))


### zooming some regisns. 

datos_precio_fecha_hora <- datos_precio_bolsa %>% mutate(hora_dia = factor(hora, levels = unique(hora))) %>% 
  arrange(Fecha, hora_dia) %>% 
  mutate(
    dia_entero = ymd_h(paste(Fecha, as.integer(str_extract(hora_dia, "[0-9]+"))))
  ) 

p1 <- datos_precio_fecha_hora %>% 
  ggplot(aes(dia_entero, precio)) + geom_line(alpha = 1) + theme_linedraw() +
  geom_line(data = contratos %>% mutate(Fecha = ymd_h(paste(Fecha, 0))), 
            aes(x = Fecha, y = `COP/Kwh-PPP`, group = Usuario, colour = Usuario), 
            inherit.aes = FALSE, size = 0.8) +
  scale_color_manual(values = c("#59c7f2", "#AC6BFF"))

p2 <- datos_precio_fecha_hora %>% 
  ggplot(aes(dia_entero, precio)) + geom_line(alpha = 1) + theme_linedraw() +
  geom_line(data = contratos %>% mutate(Fecha = ymd_h(paste(Fecha, 0))), 
            aes(x = Fecha, y = `COP/Kwh-PPP`, group = Usuario, colour = Usuario), 
            inherit.aes = FALSE, size = 0.8) +
  scale_color_manual(values = c("#59c7f2", "#AC6BFF")) +
  coord_cartesian(xlim = c(ymd_h("1995-07-20 00"), ymd_h("1996-06-01 00")), 
                  ylim = c(0, 200)) + 
  theme(legend.position = "none") + xlab(label = "") + ylab(label = "")

p1 + 
  annotation_custom(ggplotGrob(p2), 
                    xmin = ymd_h("1995-07-20 00"), xmax = ymd_h("2010-01-01 00"), 
                    ymin = 500, ymax = 2000) +
  geom_rect(data = tibble(),
    aes(xmin = ymd_h("1995-07-20 00"), xmax = ymd_h("2010-01-01 00"), ymin = 500, ymax = 2000), 
    color='black', linetype='dashed', alpha=0, inherit.aes = FALSE) +
  geom_path(
    aes(x,y,group=grp), 
        data=data.frame(
        x = c(ymd_h("1995-07-20 00"),ymd_h("1995-07-20 00"),ymd_h("1996-06-01 00"), ymd_h("2010-01-01 00")), 
        y = c(0,500,0,500),grp=c(1,1,2,2)),
            linetype='dashed', colour = "yellow")
  



# Diagrama de puntos en lugar de 
datos_precio_bolsa %>% ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_point(size  = 0.1, alpha = I(1/15)) + theme_linedraw() 
  

datos_precio_bolsa %>% ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_jitter(size  = 0.1, alpha = I(1/20), width = 5, height = 20) + theme_linedraw() 

datos_precio_bolsa %>% ggplot(aes(x = Fecha, y = precio, group = hora)) + 
  geom_jitter(size  = 0.1, alpha = I(1/20), width = 5, height = 20) + theme_linedraw() +
  geom_hline(yintercept = seq(0, 3000, 100), colour = "gray", lty = 3)


