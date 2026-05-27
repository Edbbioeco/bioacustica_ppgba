# Pacotes ----

library(suwo)

library(tidyverse)

library(av)

library(tuneR)

# Dados ----

## Metadados ----

metadados <- suwo::query_xenocanto(species = "Myrmorchilus strigilatus")

metadados

metadados |> dplyr::glimpse()

## Filtrar dados a serem baixados ----

metadados_trat <- metadados |>
  dplyr::filter(country == "Brazil" & file_extension == "wav")

metadados_trat

## Mapa das áreas ----

metadados_trat |>
  suwo::map_locations()

## Baixar os dados ----

dir.create(path = "./voc_myrmorchilus")

metadados_trat |>
  suwo::download_media(path = "./voc_myrmorchilus")

# Analisar dados ----

## Consertar os áudios ----

vocs <- purrr::map(list.files(path = "./voc_myrmorchilus",
                              full.names = TRUE),
                   \(voc){

                     av::av_audio_convert(voc,
                                          output = voc,
                                          format = "wav",
                                          sample_rate = 44100,
                                          channels = 1)
                   },
                   .progress = TRUE)

## Importar áudios ----

vocalizacoes <- purrr::map(vocs,
                           tuneR::readWave,
                           .progress = TRUE) |>
  setNames(list.files(path = "./voc_myrmorchilus") |>
             stringr::str_remove(".wav"))

vocalizacoes
