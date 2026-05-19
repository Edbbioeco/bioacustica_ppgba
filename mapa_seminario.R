# PAcotes ----

library(readxl)

library(tidyverse)

library(geobr)

library(ggview)

# Dados ----

## Registros ----

### Importar ----

loc <- readxl::read_xlsx("valores_var.xlsx")

### Visualizar ----

loc

loc |> dplyr::glimpse()

## Biomas ----

### Importar ----

biomas <- geobr::read_biomes()

### Visualizar ----

biomas

ggplot() +
  geom_sf(data = biomas)
