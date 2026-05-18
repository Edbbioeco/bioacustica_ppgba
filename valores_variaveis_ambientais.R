# Pacotes ----

library(tidyverse)

library(sf)

library(geobr)

library(terra)

library(tidyterra)

library(geodata)

library(elevatr)

library(CDSE)

# Dados ----

## Localidades ----

### Importar ----

loc <- readr::read_csv("localidades.csv")

### Visualizar ----

loc

loc |> dplyr::glimpse()

## Shapefile da Caatinga ----

### importar ----

caa <- geobr::read_biomes() |>
  dplyr::filter(name_biome == "Caatinga")

## Visualizar ----

caa

ggplot() +
  geom_sf(data = caa, color = "black", fill = "goldenrod") +
  geom_point(data = loc,
             aes(Longitude, Latitude))
