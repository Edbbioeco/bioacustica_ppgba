# Pacotes ----

library(suwo)

library(tidyverse)

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

## Lista de vocalizações ----

vocs <- list.files(path = "./voc_myrmorchilus")

vocs
