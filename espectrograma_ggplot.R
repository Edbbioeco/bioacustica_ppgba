# Pàcotes ----

library(tuneR)

library(seewave)

library(tidyverse)

# Dados ----

## Importar ----

voc <- tuneR::readWave("vocalizacao.wav")

## Visualizar ----

voc

voc |> seewave::listen(f = 0.75)

# Valores acústicos ----

## Valores do espectrograma ----

### Criar ----

espectro <- voc |> seewave::spectro(flim = c(0, 0.75),
                                    tlim = c(15, 16.75))

### Data frame dos valore ----

espectro_df <- tibble::tibble(tempo = rep(espectro$time,
                                          each = length(espectro$freq)),
                              frequencia = rep(espectro$freq,
                                               length(espectro$time)))

espectro_df
