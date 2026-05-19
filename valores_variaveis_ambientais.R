# Pacotes ----

library(tidyverse)

library(sf)

library(geobr)

library(terra)

library(tidyterra)

library(geodata)

library(elevatr)

library(writexl)

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
  elevatr::get_elev_raster(z = 7,
                           prj = caa |> sf::st_crs()) |>
  terra::rast()

### Visualizar ----

elev

ggplot() +
  tidyterra::geom_spatraster(data = elev) +
  geom_point(data = loc,
             aes(Longitude, Latitude))

## Raster de bandas espectrais ----

### Importar ----

red <- terra::rast("MYD09Q1.061_sur_refl_b01_20201226T000000_aid0001.tif")

nir <- terra::rast("MYD09Q1.061_sur_refl_b02_20201226T000000_aid0001.tif")

### Calcular SAVI ----

savi <- ((nir - red) / (nir + red + 0.5)) * (1 + 0.5)

### Visualizar ----

savi

ggplot() +
  tidyterra::geom_spatraster(data = savi) +
  geom_point(data = loc,
             aes(Longitude, Latitude))

# Valores ----

## Trasnformar pontos em shapefile ----

loc_sf <- loc |>
  sf::st_as_sf(coords = c("Longitude", "Latitude"),
               crs = 4674)

loc_sf

ggplot() +
  geom_sf(data = loc_sf)

## Extrair valores ----

lista_rasters <- list(solo, elev, bio[[19]], savi)

lista_rasters

valores_rasters <- purrr::map(lista_rasters, \(raster){

  terra::extract(x = raster, y = loc_sf) |>
    dplyr::select(2)

  }) |>
  dplyr::bind_cols()

valores_rasters

## Tratar os valores ----

valores_trat <- valores_rasters |>
  dplyr::rename("solo" = 1,
                "elevacao" = 2,
                "precipitacao_quarto_mais_frio" = 3,
                "SAVI" = 4) |>
  dplyr::mutate(Local = loc$Localidade,
                Longitude = loc$Longitude,
                Latitude = loc$Latitude,
                .before = "solo")

valores_trat

## Exportar ----

valores_trat |>
  writexl::write_xlsx("valores_var.xlsx")
