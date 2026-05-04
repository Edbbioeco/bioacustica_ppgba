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

# Valores acústicos ----

## Valores do espectrograma ----

### Criar ----

voc |> seewave::spectro(flim = c(4.2, 5.25),
                        wl = 8112,
                        wn = "blackman",
                        ovlp = 99)
