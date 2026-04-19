# Pàcotes ----

library(tuneR)

library(seewave)

library(tidyverse)

# Dados ----

## Importar ----

voc <- tuneR::readWave("vocalizacao.wav")

## Visualizar ----

voc

# Espectrograma ----

## Dados do espectrograma ----

espectro <- voc |> seewave::spectro(flim = c(0, 0.75),
                                    tlim = c(15, 16.75))
