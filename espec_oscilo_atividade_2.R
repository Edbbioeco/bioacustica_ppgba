# Pacotes ----

library(tidyverse)

library(tuneR)

library(seewave)

# Dados ----

## Importar ----

audios <- purrr::map(list.files(path = "pratica_diferenciacao/",
                                full.names = TRUE),
                     \(audio){

                       tuneR::readWave(audio)

                     }) |>
  setNames(list.files(path = "pratica_diferenciacao/") |>
             stringr::str_remove(".WAV"))

## Visualizar ----

audios

purrr::map(audios, seewave::listen)
