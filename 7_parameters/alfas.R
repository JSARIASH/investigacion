# Valore alfa tomados del siguiente documento:
# https://gestornormativo.creg.gov.co/gestor/entorno/docs/pdf/doc_creg_0155_2015.pdf
library(tibble)
alfas_comercializadoras <- tibble(
  comercializador = c("GENERCAUCA", "RUITOQUE", "EEP", "EMCARTAGO", "MUNICIPAL",
                      "CETSA", "EPM", "EDEQ", "PUTUMAYO", "ELECTRICARIBE", 
                      "ESSA", "CODENSA", "ENERTOLIMA", "CENS", "EMSA", "EPSA", 
                      "ENELAR", "ELECTROHUILA", "CHEC", "CEDELCA", "DISPAC", 
                      "ELECTROCAQUETA", "ENERCA", "EBSA", "EEC", "CEDENAR", 
                      "ENERGUAVIARE", "EMEVASI"),
  alfas = c(1, 0.93, 0.9, 0.88, 0.87, 0.85, 0.82, 0.79, 0.78, 0.76, 0.7, 0.68, 
            0.67, 0.66, 0.64, 0.58, 0.58, 0.57, 0.56, 0.53, 0.5, 0.49, 0.49, 0.49, 
            0.28, 0.23, 0.23, 0.21)
)
