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

## Raster de Quantidade Carbono do Solo ----

### Importar ----

solo <- terra::rast("out.tif")

### Visdualizar ----

solo

ggplot() +
  tidyterra::geom_spatraster(data = solo) +
  geom_point(data = loc,
             aes(Longitude, Latitude))

## Precipitação ----

### Importar ----

bio <- geodata::worldclim_country(country = "BRA",
                                  var = "bio",
                                  res = 0.5,
                                  path = getwd())

### Visualizar ----

bio

ggplot() +
  tidyterra::geom_spatraster(data = bio[[1]]) +
  geom_point(data = loc,
             aes(Longitude, Latitude))

## Raster de altitude ----

## Baixar ----

elev <- caa |>
  elevatr::get_aws_terrain(z = 8,
                           prj = caa |> sf::st_crs())

### Visualizar ----

elev

ggplot() +
  tidyterra::geom_spatraster(data = elev) +
  geom_point(data = loc,
             aes(Longitude, Latitude))
