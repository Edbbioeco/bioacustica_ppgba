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

## Valores do oscilograma ----

### Criar ----

oscilo <- voc |> seewave::oscillo(from = 15, to = 16.75)

### Data frame ----

oscilo_df <- tibble::tibble(tempo = seq(0, seewave::duration(voc),
                                        length.out = length(oscilo)),
                            amplitude = oscilo |> as.numeric())

oscilo_df
