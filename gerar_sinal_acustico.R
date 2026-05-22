# Pacotes ----

library(tuneR)

library(seewave)

library(tidyverse)

library(viridis)

library(ggview)

# Dados ----

## Importar ----

scinax <- tuneR::readWave("Scinax fuscovarius.wav")

## Visualizar ----

scinax

scinax |> seewave::spectro(flim = c(0, 5),
                           tlim = c(0, 6),
                           ovlp = 99,
                           wn = "blackman",
                           wl = 2048)
