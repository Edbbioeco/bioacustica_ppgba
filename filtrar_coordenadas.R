# Pacotes ----

library(sf)

library(tidyverse)

# Dados ----

## Dezipar ----

unzip(zipfile = "0024949-260507073636908.zip",
      exdir = "gbif")

## Importar ----

dados <-read.csv2("gbif/0024949-260507073636908.csv")

## Visualizar ----

dados

dados |> dplyr::glimpse()
