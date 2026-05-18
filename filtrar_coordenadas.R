# Pacotes ----

library(tidyverse)

library(sf)

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
  dplyr::distinct(decimalLatitude, decimalLatitude, .keep_all = TRUE) |>
  dplyr::filter(!decimalLatitude |> is.na() &
                  !decimalLongitude |> is.na()) |>
  sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"),
               crs = 4674)

dados_sf |> dplyr::pull(locality)

ggplot() +
  geom_sf(data = dados_sf)

## Exportar ----

dados_sf |> sf::st_write("pontos.shp")
