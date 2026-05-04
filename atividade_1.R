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
                        ovlp = 99,
                        palette = viridis::viridis)

## Valores do oscilograma ----

### Criar ----

oscilo <- voc |> seewave::oscillo()

### Data frame ----

oscilo_df <- tibble::tibble(tempo = seq(0,
                                        voc |> seewave::duration(),
                                        length.out = oscilo |>
                                          as.numeric() |>
                                          length()),
                            amplitude = oscilo |> as.numeric())

oscilo_df
