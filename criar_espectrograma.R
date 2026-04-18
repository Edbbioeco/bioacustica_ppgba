# Pacotees ----

library(seewave)

library(tidyverse)

library(viridis)

# Dados ----

## Importar ----

voc <- tuneR::readWave("Boana atlantica.wav")

## Visualizar ----

voc

# Espectrograma -----

## Criar espectrograma ----

voc |> seewave::spectro(flim = c(0.65, 4),
                        tlim = c(0.61, 0.91),
                        palette = viridis::inferno)
