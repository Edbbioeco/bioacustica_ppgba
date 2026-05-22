# Pacotes ----

library(tuneR)

library(seewave)

library(sonicscrewdriver)

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

# Sinal acústico ----

## Gerar múltiplos sinais acústicos ----

sinal <- do.call(tuneR::bind,
                 purrr::map(1:9,
                            \(id){

          sonicscrewdriver::sweptsine(f0 = 491.2,
                                      f1 = 4657.4,
                                      sweep.time = 0.0248)

                })
        )
