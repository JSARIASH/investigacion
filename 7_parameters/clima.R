# Datos con las fechas de los fenómenos que más impactan las presipitaciones como lo 
# son el fenómeno del niño y de la niña. 

# Yo del futuro: Estaba buscando información pero me dió pereza. Le queda a 
# usted de tarea. 

niña <- "1903–04
1906–07
1909–11
1916–18
1924–25
1928–30
1938–39
1942–43
1949–51
1954–57
1964–65
1970–72
1973–76
1983–85
1988–89
1995–96
1998–2001
2005–06
2007–08
2008–09
2010–12
2016-
2017–18
2020–22
"
niña <- str_split(niña, pattern = "\n")
niña <- unlist(niña)
niña <- unlist(str_split(niña, pattern = "–", simplify = TRUE))
niña[, 2] <- paste0(str_sub(niña[, 1], start = 1, end = 2), niña[, 2])
