# Pacotes ----

library(tuneR)

library(seewave)

library(tidyverse)

library(viridis)

library(ggview)

library(patchwork)

# Dados ----

## Importar ----

scinax <- tuneR::readWave("Scinax x signatus.wav")

## Visualizar ----

scinax

scinax |> seewave::spectro(flim = c(0, 6),
                           tlim = c(0, 3.5),
                           ovlp = 99,
                           wn = "blackman",
                           wl = 2048)

scinax |> seewave::listen()
