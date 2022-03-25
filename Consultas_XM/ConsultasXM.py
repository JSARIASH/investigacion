# Ejemplo tomado de: 
# https://github.com/EquipoAnaliticaXM/API_XM/blob/master/examples/data_extraction_using_pydataxm_using_library.ipynb
 
import datetime as dt    
from pydataxm import *                          
from pydataxm.pydataxm import ReadDB as apiXM 

objetoAPI = pydataxm.ReadDB()

df = apiXM.request_data(pydataxm.ReadDB(),       #Se indica el objeto que contiene el serivicio
                        "VentBolsaIntMoneda",       #Se indica el nombre de la métrica tal como se llama en el campo metricID
                        0,                       #Campo númerico indicando el nivel de desagregación, 0 para valores del Sistema
                        dt.date(2020, 1, 1),     #Corresponde a la fecha inicial de la consulta
                        dt.date(2020, 1, 10))
                        
df

