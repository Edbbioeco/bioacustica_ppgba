# Pàcotes ----

library(tuneR)

library(seewave)

library(tidyverse)

library(ggmagnify)

library(viridis)

library(ggview)

library(patchwork)

# Vocalização ----

## Importar ----

voc <- tuneR::readWave("C:/Users/LENOVO/OneDrive/Documentos/projeto mestrado/vocalizações/Allobates-olfersioides.wav")

## Visualizar  ----

voc

voc |> seewave::listen()
