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

# Shapefile ----

## Tratar e trasnformar em shapefile ----

dados_sf <- dados |>
  dplyr::mutate(dplyr::across(.cols = dplyr::contains("decimal"),
                            .fns = ~as.numeric(.)),
                decimalLongitude = dplyr::if_else(decimalLongitude < -50,
                                                  decimalLongitude / 10,
                                                  decimalLongitude),
                decimalLatitude = dplyr::if_else(decimalLatitude < -20,
                                                 decimalLatitude / 10,
                                                 decimalLatitude)) |>
  dplyr::filter(!decimalLatitude |> is.na() &
                  !decimalLongitude |> is.na()) |>
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

dados_sf

ggplot() +
  geom_sf(data = dados_sf)

## Filtrar ----

set.seed(123); dados_sf |>
  dplyr::slice_sample(n = 30) -> dados_sf_filtrado

dados_sf_filtrado

ggplot() +
  geom_sf(data = dados_sf_filtrado)
