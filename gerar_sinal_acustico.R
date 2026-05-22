# Pacotes ----

library(tuneR)

library(seewave)

library(sonicscrewdriver)

library(tidyverse)

library(viridis)

library(ggview)

# Dados ----

## Importar ----

scinax <- tuneR::readWave("Scinax x signatus.wav")

## Visualizar ----

scinax

scinax |> seewave::spectro(flim = c(0, 6),
                           tlim = c(0, 5),
                           ovlp = 99,
                           wn = "blackman",
                           wl = 2048)

scinax |> seewave::listen()

# Sinal acústico ----

## Silencio ----

silencio <- tuneR::silence(duration = 0.6746,
                           xunit = "time",
                           samp.rate = scinax@samp.rate,
                           pcm = TRUE,
                           stereo = FALSE)

silencio

## Gerar múltiplos sinais acústicos ----

sinal <- purrr::map(1:9,
                    \(id){

            sonicscrewdriver::sweptsine(f0 = 693.5,
                                        f1 = 5185.9,
                                        sweep.time = 0.0197,
                                        samp.rate = scinax@samp.rate,
                                        bit = 32,
                                        mode = "linear")

                    }) |>
  purrr::reduce(\(som1, som2) tuneR::bind(som1, som2))

sinal

sinal |> seewave::spectro(flim = c(0, 5.5),
                          ovlp = 99,
                          wn = "blackman",
                          wl = 2048)

sinal |> seewave::listen()

sinal_completo <- purrr::map(1:5, \(id){sinal}) |>
  purrr::reduce(\(som1, som2) tuneR::bind(som1, silencio, som2)) %>%
  tuneR::bind(silencio, ., silencio)

sinal_completo

sinal_completo |> seewave::listen()

sinal_completo |> seewave::spectro(flim = c(0, 6),
                                   ovlp = 99,
                                   wn = "blackman",
                                   wl = 2048)

